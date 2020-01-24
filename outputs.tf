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
