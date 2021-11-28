output "ui_public_ip" {
  description = "UI public ip"
  value       = data.kubernetes_service.consul-ui.status.0.load_balancer.0.ingress.0.ip
}