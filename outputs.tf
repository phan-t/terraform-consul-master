# output "deployment_id" {
#   description = "Deployment id"
#   value       = local.deployment_id
# }

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

# output "aws_private_subnet_ids" {
#   description = "Private subnet ids"
#   value       = module.infra-aws.private_subnet_ids
# }

# output "aws_security_group_allow_ssh_inbound_id" {
#   description = "Security group allow-ssh-inbound id"
#   value       = module.infra-aws.security_group_allow_ssh_inbound_id
# }

# output "aws_security_group_allow_any_private_inbound_id" {
#   description = "Security group allow-any-private-inbound id"
#   value       = module.infra-aws.security_group_allow_any_private_inbound_id
# }

output "bastion_public_fqdn" {
  description = "Public fqdn of bastion node"
  value       = module.infra-aws.bastion_public_fqdn
}

output "consul_ui_public_address" {
  description = "Consul UI public address"
  value       = "https://${module.consul-server-aws.ui_public_fqdn}"
}

output "consul_ingress_gateway_public_fqdn" {
  description = "Consul ingress gateway fqdn"
  value       = "http://${module.consul-server-aws.ingress_gateway_public_fqdn}"
}

# output "cts_private_fqdn" {
#   description = "Private fqdn of CTS node"
#   value       = module.cts-aws.private_fqdn
# }

output "grafana_public_address" {
  description = "Grafana public address"
  value       = "http://${module.grafana.public_fqdn}"
}

# output "gcp_region" {
#   description = "GCP region"
#   value       = var.gcp_region
# }

# output "deployment_name" {
#   description = "Deployment name, used to prefix resources"
#   value       = var.deployment_name
# }

# output "consul_server_private_fqdn" {
#   description = "Consul server fqdn"
#   value       = module.consul-server-aws.private_fqdn
# }

# output "boundary_controller_public_address" {
#   description = "Boundary controller public address"
#   value       = "http://${module.boundary-aws-infra.controller_public_fqdn}:9200"
# }

# output "boundary_kms_recovery_key_id" {
#   description = "Boundary KMS recovery key id"
#   value       =  module.boundary-aws-infra.kms_recovery_key_id
# }

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