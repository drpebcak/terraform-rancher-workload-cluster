provider "rancher2" {
  api_url   = local.rancher_api_url
  token_key = local.rancher_token_key
}

resource "rancher2_cluster" "cluster" {
  name        = local.name
  description = local.cluster_description

  cluster_auth_endpoint {
    enabled = local.cluster_auth_endpoint_enabled
    fqdn    = local.cluster_auth_endpoint_fqdn
  }

  rke_config {
    ingress {
      provider = local.ingress_provider
    }
    kubernetes_version = local.kubernetes_version
    cloud_provider {
      name = local.cloud_provider_name
    }
    upgrade_strategy {
      drain                  = local.upgrade_drain
      max_unavailable_worker = local.upgrade_max_unavailable_worker
      drain_input {
        delete_local_data = local.drain_delete_local_data
        force             = local.drain_force
        timeout           = local.drain_timeout
      }
    }
    services {
      kubelet {
        extra_args         = local.kubelet_extra_args
        cluster_dns_server = local.cluster_dns_server
      }
      kube_api {
        extra_args               = local.kube_api_extra_args
        service_cluster_ip_range = local.service_cluster_ip_range
        secrets_encryption_config {
          enabled = true
        }
      }
      kube_controller {
        extra_args               = local.kube_controller_extra_args
        cluster_cidr             = local.cluster_cidr
        service_cluster_ip_range = local.service_cluster_ip_range
      }
      scheduler {
        extra_args = local.scheduler_extra_args
      }
      etcd {
        backup_config {
          enabled        = true
          interval_hours = 6
          retention      = 21

          s3_backup_config {
            access_key  = aws_iam_access_key.etcd_backup_user.id
            bucket_name = aws_s3_bucket.etcd_backups.id
            endpoint    = "s3.${aws_s3_bucket.etcd_backups.region}.amazonaws.com"
            region      = aws_s3_bucket.etcd_backups.region
            secret_key  = aws_iam_access_key.etcd_backup_user.secret
            folder      = "${local.name}-etcd-backup"
          }
        }
      }
    }
  }


  depends_on = [aws_s3_bucket.etcd_backups]
}

resource "rancher2_cluster_sync" "cluster" {
  cluster_id = rancher2_cluster.cluster.id
}

resource "rancher2_cluster_role_template_binding" "deploy" {
  count            = local.deploy_user_enabled
  name             = "deploy"
  role_template_id = "cluster-owner"
  cluster_id       = rancher2_cluster_sync.cluster.id
  user_id          = local.rancher_deploy_user
}
