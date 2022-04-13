resource "aws_s3_bucket" "etcd_backups" {
  bucket_prefix = "${local.name}-etcd-backup"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "etcd_backups_acl" {
  bucket = aws_s3_bucket.etcd_backups.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "etcd_backups_versioning" {
  bucket = aws_s3_bucket.etcd_backups.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "etcd_backups_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.etcd_backups.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "etcd_backups" {
  bucket = aws_s3_bucket.etcd_backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "cluster" {
  name   = "${local.name}-cluster"
  vpc_id = local.vpc_id
  tags = {
    "kubernetes.io/cluster/${var.name}" = "owned"
  }
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

resource "aws_security_group_rule" "cluster_ingress_6443" {
  count    = local.cluster_auth_endpoint_enabled ? 1 : 0
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
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
  user_data = base64gzip(templatefile("${path.module}/files/cloud-config.yaml", {
    registration_command = "${rancher2_cluster.cluster.cluster_registration_token[0]["node_command"]} --etcd --controlplane",
    ssh_keys             = local.ssh_keys
  }))

  iam_instance_profile {
    arn = aws_iam_instance_profile.cloud_provider_master.arn
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = local.master_volume_type
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = concat([aws_security_group.cluster.id], local.extra_master_security_groups)
  }

  tags = local.master_tags

  tag_specifications {
    resource_type = "instance"

    tags = local.master_tags
  }
}

resource "aws_autoscaling_group" "master" {
  name_prefix         = "${local.name}-master"
  desired_capacity    = local.master_node_count
  max_size            = local.master_node_count
  min_size            = local.master_node_count
  vpc_zone_identifier = local.private_subnets

  launch_template {
    id      = aws_launch_template.master.id
    version = "$Latest"
  }
}

resource "aws_lb" "fqdn" {
  count              = local.cluster_auth_endpoint_enabled ? 1 : 0
  name               = "${local.name}-fqdn"
  internal           = local.cluster_auth_endpoint_internal
  load_balancer_type = "network"
  subnets            = local.public_subnets

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true

  tags = local.master_tags
}

resource "aws_lb_target_group" "fqdn" {
  count    = local.cluster_auth_endpoint_enabled ? 1 : 0
  name_prefix     = "fqdn"
  port     = 6443
  protocol = "TCP"
  vpc_id   = local.vpc_id
  tags     = local.master_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "fqdn" {
  count             = local.cluster_auth_endpoint_enabled ? 1 : 0
  load_balancer_arn = aws_lb.fqdn[0].arn
  port              = "443"
  protocol          = "TCP"

  tags = local.master_tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fqdn[0].arn
  }
}

resource "aws_autoscaling_attachment" "fqdn" {
  count                  = local.cluster_auth_endpoint_enabled ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.master.id
  lb_target_group_arn    = aws_lb_target_group.fqdn[0].arn
}

####
resource "aws_launch_template" "worker" {
  name_prefix   = "${local.name}-worker"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = local.worker_instance_type
  user_data = base64gzip(templatefile("${path.module}/files/cloud-config.yaml", {
    registration_command = "${rancher2_cluster.cluster.cluster_registration_token[0]["node_command"]} --worker",
    ssh_keys             = local.ssh_keys
  }))

  iam_instance_profile {
    arn = aws_iam_instance_profile.cloud_provider_worker.arn
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = local.worker_volume_type
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = concat([aws_security_group.cluster.id], local.extra_worker_security_groups)
  }

  tags = local.worker_tags

  tag_specifications {
    resource_type = "instance"

    tags = local.worker_tags
  }
}

resource "aws_autoscaling_group" "worker" {
  name_prefix         = "${local.name}-worker"
  desired_capacity    = local.worker_node_count
  max_size            = local.worker_node_count
  min_size            = local.worker_node_count
  vpc_zone_identifier = local.private_subnets

  launch_template {
    id      = aws_launch_template.worker.id
    version = "$Latest"
  }
}
