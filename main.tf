terraform {
  required_version = ">= 0.12"
}

locals {
  name                  = var.name
  aws_region            = var.aws_region
  master_instance_type  = var.master_instance_type
  worker_instance_type  = var.worker_instance_type
  master_node_count     = var.master_node_count
  worker_node_count     = var.worker_node_count
  ssh_keys              = var.ssh_keys
  cluster_description   = var.cluster_description
  kubernetes_version    = var.kubernetes_version
  cloud_provider_name   = var.cloud_provider_name
  backup_interval_hours = var.backup_interval_hours
  backup_retention      = var.backup_retention
  rancher_token_key     = ""
  rancher_api_url       = ""
  rancher_deploy_user   = ""
}

provider "aws" {
  region = local.aws_region
}
