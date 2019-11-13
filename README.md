<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_region | Region to deploy AWS resources in | string | `"us-east-1"` | no |
| backup\_interval\_hours | Interval between etcd backups | number | `"6"` | no |
| backup\_retention | Number of etcd backups to retain | number | `"12"` | no |
| cloud\_provider\_name | RKE Cloud Provider name to enable | string | `"aws"` | no |
| cluster\_description | Description of K8S clusters for Rancher | string | `"Terraform managed RKE cluster"` | no |
| kubernetes\_version | Version of Kubernetes to install | string | `"v1.15.5-rancher1-2"` | no |
| master\_instance\_type | Instance Types for K8S Master nodes | string | `"m5a.large"` | no |
| name | Name to identify Kubernetes cluster | string | n/a | yes |
| rancher\_api\_url | URL for Rancher API | string | n/a | yes |
| rancher\_deploy\_user | ID of Deploy user inside Rancher | string | n/a | yes |
| rancher\_token\_key | API Token for Rancher Admin | string | n/a | yes |
| ssh\_keys | Public SSH keys to give to instances | list | `[ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5O7k6gRYCU7YPkCH6dyXVW10izMAkDAQtQxNxdRE22 drpebcak" ]` | no |
| worker\_instance\_type | Instance Types for K8S Worker nodes | string | `"m5a.large"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id |  |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
