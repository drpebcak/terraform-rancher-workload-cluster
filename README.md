<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_iam_access_key.etcd_backup_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_instance_profile.cloud_provider_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_instance_profile.cloud_provider_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.cloud_provider_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cloud_provider_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloud_provider_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.cloud_provider_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_user.etcd_backup_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.etcd_backup_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_launch_template.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_s3_bucket.etcd_backups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.etcd_backups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_all_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_ingress_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.cluster_ingress_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [rancher2_cluster.cluster](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster) | resource |
| [rancher2_cluster_role_template_binding.deploy](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_role_template_binding) | resource |
| [rancher2_cluster_sync.cluster](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_sync) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region to deploy AWS resources in | `string` | `"us-east-1"` | no |
| <a name="input_backup_interval_hours"></a> [backup\_interval\_hours](#input\_backup\_interval\_hours) | Interval between etcd backups | `number` | `6` | no |
| <a name="input_backup_retention"></a> [backup\_retention](#input\_backup\_retention) | Number of etcd backups to retain | `number` | `12` | no |
| <a name="input_cloud_provider_name"></a> [cloud\_provider\_name](#input\_cloud\_provider\_name) | RKE Cloud Provider name to enable | `string` | `"aws"` | no |
| <a name="input_cluster_cidr"></a> [cluster\_cidr](#input\_cluster\_cidr) | Cidr to use for overlay network | `string` | `null` | no |
| <a name="input_cluster_description"></a> [cluster\_description](#input\_cluster\_description) | Description of K8S clusters for Rancher | `string` | `"Terraform managed RKE cluster"` | no |
| <a name="input_cluster_dns_server"></a> [cluster\_dns\_server](#input\_cluster\_dns\_server) | IP for cluster dns service. Should be within service\_cluster\_ip\_range | `string` | `null` | no |
| <a name="input_deploy_user_enabled"></a> [deploy\_user\_enabled](#input\_deploy\_user\_enabled) | Define whether to give permissions for a deploy user | `bool` | `true` | no |
| <a name="input_drain_delete_local_data"></a> [drain\_delete\_local\_data](#input\_drain\_delete\_local\_data) | Delete local data while draining | `bool` | `false` | no |
| <a name="input_drain_force"></a> [drain\_force](#input\_drain\_force) | Force the drain of RKE Nodes | `bool` | `false` | no |
| <a name="input_drain_timeout"></a> [drain\_timeout](#input\_drain\_timeout) | Node drain timeout | `number` | `60` | no |
| <a name="input_extra_master_security_groups"></a> [extra\_master\_security\_groups](#input\_extra\_master\_security\_groups) | A list of extra security groups to assign to master nodes | `list(string)` | `[]` | no |
| <a name="input_extra_worker_security_groups"></a> [extra\_worker\_security\_groups](#input\_extra\_worker\_security\_groups) | A list of extra security groups to assign to worker nodes | `list(string)` | `[]` | no |
| <a name="input_ingress_provider"></a> [ingress\_provider](#input\_ingress\_provider) | Provider for ingress. Either 'nginx' or 'none' | `string` | `null` | no |
| <a name="input_kube_api_extra_args"></a> [kube\_api\_extra\_args](#input\_kube\_api\_extra\_args) | extra\_args for kube-api | `map(any)` | `null` | no |
| <a name="input_kube_controller_extra_args"></a> [kube\_controller\_extra\_args](#input\_kube\_controller\_extra\_args) | extra\_args for kube-controller | `map(any)` | `null` | no |
| <a name="input_kubelet_extra_args"></a> [kubelet\_extra\_args](#input\_kubelet\_extra\_args) | extra\_args for kubelet | `map(any)` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of Kubernetes to install | `string` | `"v1.17.0-rancher1-2"` | no |
| <a name="input_master_instance_type"></a> [master\_instance\_type](#input\_master\_instance\_type) | Instance Types for K8S Master nodes | `string` | `"m5a.large"` | no |
| <a name="input_master_node_count"></a> [master\_node\_count](#input\_master\_node\_count) | Number of Master nodes to provision | `number` | `3` | no |
| <a name="input_master_tags"></a> [master\_tags](#input\_master\_tags) | Map of tags for master nodes to merge with defaults | `map(any)` | `{}` | no |
| <a name="input_master_volume_type"></a> [master\_volume\_type](#input\_master\_volume\_type) | Volume Type for K8S Master nodes | `string` | `"gp3"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to identify Kubernetes cluster | `string` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets to create ec2 instances in | `list(string)` | n/a | yes |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | URL for Rancher API | `string` | n/a | yes |
| <a name="input_rancher_deploy_user"></a> [rancher\_deploy\_user](#input\_rancher\_deploy\_user) | ID of Deploy user inside Rancher | `string` | n/a | yes |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | API Token for Rancher Admin | `string` | n/a | yes |
| <a name="input_scheduler_extra_args"></a> [scheduler\_extra\_args](#input\_scheduler\_extra\_args) | extra\_args for kube-scheduler | `map(any)` | `null` | no |
| <a name="input_service_cluster_ip_range"></a> [service\_cluster\_ip\_range](#input\_service\_cluster\_ip\_range) | Cidr to use for services | `string` | `null` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | Public SSH keys to give to instances | `list(string)` | <pre>[<br>  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak"<br>]</pre> | no |
| <a name="input_upgrade_drain"></a> [upgrade\_drain](#input\_upgrade\_drain) | Drain RKE Nodes | `bool` | `false` | no |
| <a name="input_upgrade_max_unavailable_worker"></a> [upgrade\_max\_unavailable\_worker](#input\_upgrade\_max\_unavailable\_worker) | Number or percentage of workers that can be unavailable at the same time | `string` | `"10%"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for this cluster to be created in. | `string` | n/a | yes |
| <a name="input_worker_instance_type"></a> [worker\_instance\_type](#input\_worker\_instance\_type) | Instance Types for K8S Worker nodes | `string` | `"m5a.large"` | no |
| <a name="input_worker_node_count"></a> [worker\_node\_count](#input\_worker\_node\_count) | Number of Worker nodes to provision | `number` | `3` | no |
| <a name="input_worker_tags"></a> [worker\_tags](#input\_worker\_tags) | Map of tags for worker nodes to merge with defaults | `map(any)` | `{}` | no |
| <a name="input_worker_volume_type"></a> [worker\_volume\_type](#input\_worker\_volume\_type) | Volume Type for K8S Worker nodes | `string` | `"gp3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_default_worker_security_group_id"></a> [default\_worker\_security\_group\_id](#output\_default\_worker\_security\_group\_id) | n/a |
| <a name="output_master_tags"></a> [master\_tags](#output\_master\_tags) | n/a |
| <a name="output_registration_command"></a> [registration\_command](#output\_registration\_command) | n/a |
| <a name="output_worker_iam_role"></a> [worker\_iam\_role](#output\_worker\_iam\_role) | n/a |
| <a name="output_worker_instance_profile"></a> [worker\_instance\_profile](#output\_worker\_instance\_profile) | n/a |
| <a name="output_worker_instance_profile_name"></a> [worker\_instance\_profile\_name](#output\_worker\_instance\_profile\_name) | n/a |
| <a name="output_worker_security_groups"></a> [worker\_security\_groups](#output\_worker\_security\_groups) | n/a |
| <a name="output_worker_tags"></a> [worker\_tags](#output\_worker\_tags) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
