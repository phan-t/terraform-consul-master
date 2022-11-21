output "root_token" {
  value     = hcp_consul_cluster_root_token.token.secret_id
  sensitive = true
}

output "public_endpoint_url" {
  value = hcp_consul_cluster.consul.consul_public_endpoint_url
}

output "private_endpoint_url" {
  value = hcp_consul_cluster.consul.consul_private_endpoint_url
}