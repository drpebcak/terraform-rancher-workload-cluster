terraform {
  required_version = ">= 0.12"
}

locals {
  name                  = var.name
  aws_region            = var.aws_region
  master_instance_type  = var.master_instance_type
  worker_instance_type  = var.worker_instance_type
  master_node_count     = var.master_node_count
  master_volume_type    = var.master_volume_type
  worker_node_count     = var.worker_node_count
  worker_volume_type    = var.worker_volume_type
  ssh_keys              = var.ssh_keys
  extra_cmds            = var.extra_cmds
  cluster_description   = var.cluster_description
  kubernetes_version    = var.kubernetes_version
  cloud_provider_name   = var.cloud_provider_name
  backup_interval_hours = var.backup_interval_hours
  backup_retention      = var.backup_retention
  rancher_token_key     = var.rancher_token_key
  rancher_api_url       = var.rancher_api_url
  rancher_deploy_user   = var.rancher_deploy_user
  private_subnets       = var.private_subnets
  public_subnets        = var.public_subnets
  deploy_user_enabled   = var.deploy_user_enabled ? 1 : 0
  vpc_id                = var.vpc_id

  extra_master_security_groups = var.extra_master_security_groups
  extra_worker_security_groups = var.extra_worker_security_groups

  scheduler_extra_args       = var.scheduler_extra_args
  kube_controller_extra_args = var.kube_controller_extra_args
  kube_api_extra_args        = var.kube_api_extra_args
  kubelet_extra_args         = var.kubelet_extra_args
  kubeproxy_extra_args       = var.kubeproxy_extra_args
  ingress_provider           = var.ingress_provider
  cluster_cidr               = var.cluster_cidr
  service_cluster_ip_range   = var.service_cluster_ip_range
  cluster_dns_server         = var.cluster_dns_server
  nodelocal_ip_address       = var.nodelocal_ip_address

  master_tags = merge({ Name = "${local.name}-master", "kubernetes.io/cluster/${local.name}" = "owned" }, var.master_tags)
  worker_tags = merge({ Name = "${local.name}-worker", "kubernetes.io/cluster/${local.name}" = "owned" }, var.worker_tags)

  upgrade_drain                  = var.upgrade_drain
  upgrade_max_unavailable_worker = var.upgrade_max_unavailable_worker
  drain_delete_local_data        = var.drain_delete_local_data
  drain_force                    = var.drain_force
  drain_timeout                  = var.drain_timeout
  cluster_auth_endpoint_enabled  = var.cluster_auth_endpoint_enabled
  cluster_auth_endpoint_fqdn     = var.cluster_auth_endpoint_fqdn
  cluster_auth_endpoint_internal = var.cluster_auth_endpoint_internal

  kube_api_audit_log_enabled = var.kube_api_audit_log_enabled
  kube_api_audit_log_config_max_age = var.kube_api_audit_log_config_max_age
  kube_api_audit_log_config_max_backup = var.kube_api_audit_log_config_max_backup
  kube_api_audit_log_config_max_size = var.kube_api_audit_log_config_max_size
  kube_api_audit_log_config_path = var.kube_api_audit_log_config_path
  kube_api_audit_log_config_format = var.kube_api_audit_log_config_format
}
