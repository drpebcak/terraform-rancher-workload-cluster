provider "rancher2" {
  api_url   = local.rancher_api_url
  token_key = local.rancher_token_key
}

resource "rancher2_cluster" "cluster" {
  name        = local.name
  description = local.cluster_description

  rke_config {
    kubernetes_version = local.kubernetes_version
    cloud_provider {
      name = local.cloud_provider_name
    }
  }
}

resource "rancher2_cluster_sync" "cluster" {
  cluster_id = rancher2_cluster.cluster.id
}

resource "rancher2_etcd_backup" "cluster" {
  backup_config {
    enabled        = true
    interval_hours = local.backup_interval_hours
    retention      = local.backup_retention

    s3_backup_config {
      access_key  = aws_iam_access_key.etcd_backup_user.id
      bucket_name = aws_s3_bucket.etcd_backups.id
      endpoint    = "s3.${aws_s3_bucket.etcd_backups.region}.amazonaws.com"
      region      = aws_s3_bucket.etcd_backups.region
      secret_key  = aws_iam_access_key.etcd_backup_user.secret
    }
  }
  cluster_id = rancher2_cluster_sync.cluster.id
  name       = "${local.name}-etcd-backup"
}

resource "rancher2_cluster_role_template_binding" "deploy" {
  name             = "deploy"
  role_template_id = "cluster-owner"
  cluster_id       = rancher2_cluster_sync.cluster.id
  user_id          = local.rancher_deploy_user
}
