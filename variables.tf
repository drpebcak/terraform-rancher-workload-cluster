variable "name" {
  description = "Name to identify Kubernetes cluster"
  type        = string
}

variable "aws_region" {
  default     = "us-east-1"
  description = "Region to deploy AWS resources in"
  type        = string
}

variable "master_instance_type" {
  default     = "m5a.large"
  description = "Instance Types for K8S Master nodes"
  type        = string
}

variable "worker_instance_type" {
  default     = "m5a.large"
  description = "Instance Types for K8S Worker nodes"
  type        = string
}

variable "ssh_keys" {
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak"]
  description = "Public SSH keys to give to instances"
  type        = list
}

variable "cluster_description" {
  default     = "Terraform managed RKE cluster"
  description = "Description of K8S clusters for Rancher"
  type        = string
}

variable "kubernetes_version" {
  default     = "v1.15.5-rancher1-2"
  description = "Version of Kubernetes to install"
  type        = string
}

variable "cloud_provider_name" {
  default     = "aws"
  description = "RKE Cloud Provider name to enable"
  type        = string
}

variable "backup_interval_hours" {
  default     = 6
  description = "Interval between etcd backups"
  type        = number
}

variable "backup_retention" {
  default     = 12
  description = "Number of etcd backups to retain"
  type        = number
}

variable "rancher_token_key" {
  description = "API Token for Rancher Admin"
  type        = string
}

variable "rancher_api_url" {
  description = "URL for Rancher API"
  type        = string
}

variable "rancher_deploy_user" {
  description = "ID of Deploy user inside Rancher"
  type        = string
}
