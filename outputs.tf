/*
output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
*/
output "deployment_id" {
  description = "Deployment id"
  value       = local.deployment_id
}

output "consul_ui_public_address" {
  description = "Consul UI public address"
  value       = "https://${module.consul-aws-server.ui_public_fqdn}"
}

output "consul_ingress_gateway_public_fqdn" {
  description = "Consul ingress gateway fqdn"
  value       = "https://${module.consul-aws-server.ingress_gateway_public_fqdn}:8080"
}

output "consul_server_private_fqdn" {
  description = "Consul server fqdn"
  value       = module.consul-aws-server.private_fqdn
}

output "bastion_public_fqdn" {
  description = "Public fqdn of bastion node"
  value       = module.aws-infra.bastion_public_fqdn
}

output "cts_private_fqdn" {
  description = "Private fqdn of CTS node"
  value       = module.cts-aws.private_fqdn
}

output "boundary_controller_public_address" {
  description = "Boundary controller public address"
  value       = "http://${module.boundary-aws-infra.controller_public_fqdn}:9200"
}

output "boundary_kms_recovery_key_id" {
  description = "Boundary KMS recovery key id"
  value       =  module.boundary-aws-infra.kms_recovery_key_id
}