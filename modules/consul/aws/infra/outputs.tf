output "consul_ui_fqdn" {
  description = "Consul UI fqdn"
  value       = data.kubernetes_service.consul-ui.status.0.load_balancer.0.ingress.0.hostname
}

output "consul_ingress_gateway_fqdn" {
  description = "Consul ingress gateway fqdn"
  value       = data.kubernetes_service.consul-ingress-gateway.status.0.load_balancer.0.ingress.0.hostname
}

output "consul_server_fqdn" {
  description = "Consul server fqdn"
  value       = data.kubernetes_pod.consul-server.spec.0.node_name
}