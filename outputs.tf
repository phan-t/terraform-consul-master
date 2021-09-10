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
  value       = "https://${module.eks-server.consul_ui_fqdn}"
}

output "consul_ingress_gateway_fqdn" {
  description = "Consul ingress gateway fqdn"
  value       = module.eks-server.consul_ingress_gateway_fqdn
}

output "consul_server_fqdn" {
  description = "Consul server fqdn"
  value       = module.eks-server.consul_server_fqdn
}

output "bastion_node_public_fqdn" {
  description = "Public fqdn of bastion node"
  value       = module.aws.bastion_node_public_fqdn
}

output "cts_node_private_fqdn" {
  description = "Private fqdn of CTS node"
  value       = module.cts-node.cts_node_private_fqdn
}

output "boundary_controller_public_address" {
  description = "Boundary controller public address"
  value       = "http://${module.boundary.controller_public_fqdn}:9200"
}

output "boundary_kms_recovery_key_id" {
  description = "Boundary KMS recovery key id"
  value       =  module.boundary.kms_recovery_key_id
}