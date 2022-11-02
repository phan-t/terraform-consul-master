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

output "security_group_ssh_id" {
  description = "Security group allow-ssh-inbound id"
  value       = module.sg-ssh.security_group_id
}

output "bastion_public_fqdn" {
  description = "Public fqdn of bastion"
  value       = aws_instance.bastion.public_dns
}

output "eks_cluster_id" {
  description = "EKS cluster id"
  value       = module.eks.cluster_id
}