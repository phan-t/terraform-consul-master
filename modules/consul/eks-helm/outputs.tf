output "service_ext_fqdn_consul_ui" {
  description = "Get load-balancer FQDN for Consul UI"
  value       = data.kubernetes_service.consul-ui.status.0.load_balancer.0.ingress.0.hostname
}

output "node_fqdn_consul_server" {
  description = "Get kubernetes node fqdn running Consul server pod"
  value       = data.kubernetes_pod.consul-server.spec.0.node_name
}