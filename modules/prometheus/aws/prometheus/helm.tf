# prometheus
resource "helm_release" "prometheus" {
  name          = "${var.deployment_name}-prometheus"
  chart         = "prometheus"
  repository    = "https://prometheus-community.github.io/helm-charts"
  timeout       = "300"
  wait_for_jobs = true
  depends_on    = [
    helm_release.consul-server
  ]

  set {
    name  = "alertmanager.enabled"
    value = false
  }

  set {
    name  = "nodeExporter.enabled"
    value = false
  }

  set {
    name  = "pushgateway.enabled"
    value = false
  }
}