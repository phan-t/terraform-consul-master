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

output "federation_secret" {
  description = "Federation secret"
  value       = data.kubernetes_secret.consul-federation-secret.data
}

output "bootstrap_acl_token" {
  description = "ACL bootstrap token"
  value       = data.kubernetes_secret.consul-bootstrap-acl-token.data.token
}

output "primary_datacenter_name" {
  description = "Primary datacenter name"
  value       = "${var.deployment_name}-aws"
}

output "prometheus_acl_token_secret" {
  value = data.consul_acl_token_secret_id.prometheus.secret_id
}