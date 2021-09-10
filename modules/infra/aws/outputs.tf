output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet ids"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet ids"
  value       = module.vpc.private_subnets
}

output "security_group_allow_ssh_inbound_id" {
  description = "Security group allow-ssh-inbound id"
  value       = aws_security_group.allow-ssh-inbound.id
}

output "security_group_allow_any_private_inbound_id" {
  description = "Security group allow-any-private-inbound id"
  value       = aws_security_group.allow-any-private-inbound.id
}

output "bastion_public_fqdn" {
  description = "Public fqdn of bastion"
  value       = aws_instance.bastion.public_dns
}