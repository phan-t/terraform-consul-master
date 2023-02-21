output "ingress_public_fqdn" {
  description = "Ingress gateway public fqdn"
  value       = data.kubernetes_service.consul-ingress-gateway.status.0.load_balancer.0.ingress.0.hostname
}

# output "default_peering_token" {
#   value = consul_peering_token.aws-gcp-default.peering_token
# }