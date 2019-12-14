<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region | Region to deploy AWS resources in | string | `"us-east-1"` | no |
| backup\_interval\_hours | Interval between etcd backups | number | `"6"` | no |
| backup\_retention | Number of etcd backups to retain | number | `"12"` | no |
| cloud\_provider\_name | RKE Cloud Provider name to enable | string | `"aws"` | no |
| cluster\_description | Description of K8S clusters for Rancher | string | `"Terraform managed RKE cluster"` | no |
| deploy\_user\_enabled | Define whether to give permissions for a deploy user | bool | `"true"` | no |
| extra\_master\_security\_groups | A list of extra security groups to assign to master nodes | list(string) | `[]` | no |
| extra\_worker\_security\_groups | A list of extra security groups to assign to worker nodes | list(string) | `[]` | no |
| kube\_api\_extra\_args | extra_args for kube-api | map | `"null"` | no |
| kube\_controller\_extra\_args | extra_args for kube-controller | map | `"null"` | no |
| kubelet\_extra\_args | extra_args for kubelet | map | `"null"` | no |
| kubernetes\_version | Version of Kubernetes to install | string | `"v1.15.5-rancher1-2"` | no |
| master\_instance\_type | Instance Types for K8S Master nodes | string | `"m5a.large"` | no |
| master\_node\_count | Number of Master nodes to provision | number | `"3"` | no |
| name | Name to identify Kubernetes cluster | string | n/a | yes |
| private\_subnets | A list of private subnets to create ec2 instances in | list(string) | n/a | yes |
| rancher\_api\_url | URL for Rancher API | string | n/a | yes |
| rancher\_deploy\_user | ID of Deploy user inside Rancher | string | n/a | yes |
| rancher\_token\_key | API Token for Rancher Admin | string | n/a | yes |
| scheduler\_extra\_args | extra_args for kube-scheduler | map | `"null"` | no |
| ssh\_keys | Public SSH keys to give to instances | list(string) | `[ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak" ]` | no |
| vpc\_id | VPC ID for this cluster to be created in. | string | n/a | yes |
| worker\_instance\_type | Instance Types for K8S Worker nodes | string | `"m5a.large"` | no |
| worker\_node\_count | Number of Worker nodes to provision | number | `"3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
