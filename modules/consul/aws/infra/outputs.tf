output "cluster_id" {
  description = "EKS cluster id"
  value       = module.eks.cluster_id
}

output "ui_public_fqdn" {
  description = "UI public fqdn"
  value       = data.kubernetes_service.consul-ui.status.0.load_balancer.0.ingress.0.hostname
}

output "ingress_gateway_public_fqdn" {
  description = "Ingress gateway public fqdn"
  value       = data.kubernetes_service.consul-ingress-gateway.status.0.load_balancer.0.ingress.0.hostname
}

output "private_fqdn" {
  description = "Private fqdn"
  value       = data.kubernetes_pod.consul-server.spec.0.node_name
}