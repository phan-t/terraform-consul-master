data "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "consul"
  }
  depends_on  = [
    helm_release.grafana
  ]
}