module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  name = local.name
  cidr = "10.106.0.0/16"

  azs             = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  public_subnets  = ["10.106.1.0/24", "10.106.2.0/24", "10.106.3.0/24"]
  private_subnets = ["10.106.4.0/24", "10.106.5.0/24", "10.106.6.0/24"]

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true

  tags = {
    "Name" = local.name
  }
}

resource "aws_s3_bucket" "etcd_backups" {
  bucket        = "${local.name}-etcd-backup"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_security_group" "cluster" {
  name   = "${local.name}-cluster"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "cluster_all_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "cluster_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "cluster_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "cluster_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
}

#############################
### Create Nodes
#############################
resource "aws_launch_template" "master" {
  name_prefix   = "${local.name}-master"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = local.master_instance_type
  user_data     = base64gzip(templatefile("${path.module}/files/cloud-config.yaml", { registration_command = "${rancher2_cluster.cluster.cluster_registration_token[0]["node_command"]} --etcd --controlplane", ssh_keys = local.ssh_keys }))

  iam_instance_profile {
    arn = aws_iam_instance_profile.cloud_provider_master.arn
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = [aws_security_group.cluster.id]
  }

  tags = {
    Name = "${local.name}-master"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                  = "${local.name}-master"
      "kubernetes.io/cluster/${local.name}" = "true"
    }
  }
}

resource "aws_autoscaling_group" "master" {
  name_prefix         = "${local.name}-master"
  desired_capacity    = local.master_node_count
  max_size            = local.master_node_count
  min_size            = local.master_node_count
  vpc_zone_identifier = module.vpc.private_subnets

  launch_template {
    id      = aws_launch_template.master.id
    version = "$Latest"
  }
}
####
resource "aws_launch_template" "worker" {
  name_prefix   = "${local.name}-worker"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = local.worker_instance_type
  user_data     = base64gzip(templatefile("${path.module}/files/cloud-config.yaml", { registration_command = "${rancher2_cluster.cluster.cluster_registration_token[0]["node_command"]} --worker", ssh_keys = local.ssh_keys }))

  iam_instance_profile {
    arn = aws_iam_instance_profile.cloud_provider_worker.arn
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = [aws_security_group.cluster.id]
  }

  tags = {
    Name = "${local.name}-worker"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                  = "${local.name}-worker"
      "kubernetes.io/cluster/${local.name}" = "true"
    }
  }
}

resource "aws_autoscaling_group" "worker" {
  name_prefix         = "${local.name}-worker"
  desired_capacity    = local.worker_node_count
  max_size            = local.worker_node_count
  min_size            = local.worker_node_count
  vpc_zone_identifier = module.vpc.private_subnets

  launch_template {
    id      = aws_launch_template.worker.id
    version = "$Latest"
  }
}
