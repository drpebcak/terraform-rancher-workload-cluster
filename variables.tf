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
  default     = "m6a.large"
  description = "Instance Types for K8S Master nodes"
  type        = string
}

variable "master_volume_type" {
  default     = "gp3"
  description = "Volume Type for K8S Master nodes"
  type        = string
}

variable "worker_instance_type" {
  default     = "m6a.large"
  description = "Instance Types for K8S Worker nodes"
  type        = string
}

variable "worker_volume_type" {
  default     = "gp3"
  description = "Volume Type for K8S Worker nodes"
  type        = string
}

variable "master_node_count" {
  default     = 3
  description = "Number of Master nodes to provision"
  type        = number
}

variable "worker_node_count" {
  default     = 3
  description = "Number of Worker nodes to provision"
  type        = number
}

variable "deploy_user_enabled" {
  default     = true
  type        = bool
  description = "Define whether to give permissions for a deploy user"
}

variable "ssh_keys" {
  default     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak"]
  description = "Public SSH keys to give to instances"
  type        = list(string)
}

variable "cluster_description" {
  default     = "Terraform managed RKE cluster"
  description = "Description of K8S clusters for Rancher"
  type        = string
}

variable "kubernetes_version" {
  default     = "v1.17.0-rancher1-2"
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

variable "vpc_id" {
  type        = string
  description = "VPC ID for this cluster to be created in."
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnets to create ec2 instances in"
}

variable "public_subnets" {
  default     = null
  type        = list(string)
  description = "A list of public subnets to create ec2 instances in"
}

variable "extra_worker_security_groups" {
  default     = []
  type        = list(string)
  description = "A list of extra security groups to assign to worker nodes"
}

variable "extra_master_security_groups" {
  default     = []
  type        = list(string)
  description = "A list of extra security groups to assign to master nodes"
}

variable "scheduler_extra_args" {
  default     = null
  type        = map(any)
  description = "extra_args for kube-scheduler"
}

variable "kube_controller_extra_args" {
  default     = null
  type        = map(any)
  description = "extra_args for kube-controller"
}

variable "kube_api_extra_args" {
  default     = null
  type        = map(any)
  description = "extra_args for kube-api"
}

variable "kubelet_extra_args" {
  default     = null
  type        = map(any)
  description = "extra_args for kubelet"
}

variable "kubeproxy_extra_args" {
  default     = null
  type        = map(any)
  description = "extra_args for kube-proxy"
}

variable "master_tags" {
  default     = {}
  type        = map(any)
  description = "Map of tags for master nodes to merge with defaults"
}

variable "worker_tags" {
  default     = {}
  type        = map(any)
  description = "Map of tags for worker nodes to merge with defaults"
}

variable "upgrade_drain" {
  default     = false
  type        = bool
  description = "Drain RKE Nodes"
}

variable "drain_delete_local_data" {
  default     = false
  type        = bool
  description = "Delete local data while draining"
}

variable "upgrade_max_unavailable_worker" {
  default     = "10%"
  type        = string
  description = "Number or percentage of workers that can be unavailable at the same time"
}

variable "drain_force" {
  default     = false
  type        = bool
  description = "Force the drain of RKE Nodes"
}

variable "drain_timeout" {
  default     = 60
  type        = number
  description = "Node drain timeout"
}

variable "ingress_provider" {
  default     = null
  type        = string
  description = "Provider for ingress. Either 'nginx' or 'none'"
}

variable "cluster_cidr" {
  default     = null
  type        = string
  description = "Cidr to use for overlay network"
}

variable "service_cluster_ip_range" {
  default     = null
  type        = string
  description = "Cidr to use for services"
}

variable "cluster_dns_server" {
  default     = null
  type        = string
  description = "IP for cluster dns service. Should be within service_cluster_ip_range"
}

variable "cluster_auth_endpoint_fqdn" {
  default     = null
  description = "fqdn for cluster auth endpoint"
  type        = string
}

variable "cluster_auth_endpoint_enabled" {
  default     = false
  description = "Enable cluster auth endpoint"
  type        = bool
}

variable "cluster_auth_endpoint_internal" {
  default     = false
  description = "Controls whether the load balancer for the cluster fqdn will be public or internal"
  type        = bool
}

variable "nodelocal_ip_address" {
  default     = ""
  description = "Defines the static and cluster-unique IP used for the nodelocal dns pod"
  type        = string
}
