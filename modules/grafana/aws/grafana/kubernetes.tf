data "kubernetes_service" "grafana" {
  metadata {
    name = "grafana"
  }
  depends_on = [
    helm_release.grafana
  ]
}