output "vpc_id" {
  description = "AWS VPC id"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "AWS private subnets"
  value       = module.vpc.private_subnets
}