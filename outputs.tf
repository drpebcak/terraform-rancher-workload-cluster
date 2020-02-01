output "cluster_id" {
  value = rancher2_cluster.cluster.id
}

output "registration_command" {
  value = rancher2_cluster.cluster.cluster_registration_token[0]["node_command"]
}

output "master_tags" {
  value = local.master_tags
}

output "worker_tags" {
  value = local.worker_tags
}

output "worker_instance_profile" {
  value = aws_iam_instance_profile.cloud_provider_worker.arn
}

output "worker_security_groups" {
  value = concat([aws_security_group.cluster.id], local.extra_worker_security_groups)
}
