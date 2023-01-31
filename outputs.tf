// generic outputs

output "deployment_id" {
  description = "Deployment identifier"
  value       = local.deployment_id
}

// amazon web services (aws) outputs

output "aws_bastion_public_fqdn" {
  description = "AWS public fqdn of bastion node"
  value       = module.infra-aws.bastion_public_fqdn
}

# output "aws_consul_ingress_gateway_public_fqdn" {
#   description = "Consul ingress gateway fqdn"
#   value       = "http://${module.consul-server-aws.ingress_gateway_public_fqdn}"
# }

# output "aws_grafana_public_fqdn" {
#   description = "Grafana public fqdn"
#   value       = "http://${module.grafana.public_fqdn}"
# }

// google gloud platform (gcp) outputs

output "gcp_consul_ui_public_fqdn" {
  description = "GCP consul datacenter ui public fqdn"
  value       = "https://${module.consul-server-gcp.ui_public_fqdn}"
}

output "gcp_consul_bootstrap_acl_token" {
  description = "Consul acl bootstrap token"
  value       = module.consul-server-gcp.bootstrap_acl_token
  sensitive   = true
}

// hashiCorp cloud platform (hcp) outputs

output "hcp_consul_public_fqdn" {
  description = "HCP consul public fqdn"
  value       = module.hcp-consul.public_endpoint_url
}

output "hcp_consul_root_token" {
  description = "HCP consul root token"
  value       = module.hcp-consul.root_token
  sensitive   = true
}

output "hcp_vault_admin_token" {
  description = "HCP vault admin token"
  value       = module.hcp-vault.admin_token
  sensitive   = true
}

output "hcp_vault_public_fqdn" {
  description = "HCP vault public fqdn"
  value       = module.hcp-vault.public_endpoint_url
}

output "hcp_boundary_public_fqdn" {
  description = "HCP boundary public fqdn"
  value       = module.hcp-boundary.public_endpoint_url
}