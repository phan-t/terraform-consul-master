/*
output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
*/
output "aws_eks_cluster_name" {
  description = "AWS EKS cluster name"
  value       = local.aws_eks_cluster_name 
}

output "consul_ui_fqdn" {
  description = "Consul UI fqdn"
  value       = module.eks-server.consul_ui_fqdn
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
  value       = module.aws.cts_node_private_fqdn
}