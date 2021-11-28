output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = module.gke.endpoint
}

output "cluster_ca_certificate" {
  description = "GKE ca certificate"
  value       = module.gke.ca_certificate
}

output "vpc_name" {
  description = "VPC name"
  value = module.vpc.network_name
}