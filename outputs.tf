output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "bastion_public_fqdn" {
  description = "Public fqdn of bastion node"
  value       = module.infra-aws.bastion_public_fqdn
}

output "consul_primary_ui_public_address" {
  description = "Consul datacenter primary ui public address"
  value       = "https://${module.consul-server-aws.ui_public_fqdn}"
}

output "consul_secondary_ui_public_address" {
  description = "Consul datacenter secondary ui public address"
  value       = "https://${module.consul-server-gcp.ui_public_ip}"
}

output "consul_ingress_gateway_public_fqdn" {
  description = "Consul ingress gateway fqdn"
  value       = "http://${module.consul-server-aws.ingress_gateway_public_fqdn}"
}

output "consul_bootstrap_acl_token" {
  description = "Consul acl bootstrap token"
  value       = module.consul-server-aws.bootstrap_acl_token
  sensitive   = true
}

output "grafana_public_address" {
  description = "Grafana public address"
  value       = "http://${module.grafana.public_fqdn}"
}

output "hcp_vault_admin_token" {
  description = "HCP vault admin token"
  value       = module.hcp-vault.admin_token
  sensitive   = true
}

output "hcp_vault_public_endpoint_url" {
  description = "HCP vault public url"
  value       = module.hcp-vault.public_endpoint_url
}

output "hcp_boundary_public_endpoint_url" {
  description = "HCP boundary public url"
  value       = module.hcp-boundary.public_endpoint_url
}