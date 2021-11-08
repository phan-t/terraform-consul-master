resource "local_file" "grafana-helm-values" {
  content = templatefile("${path.root}/examples/templates/grafana-helm.yml", {
    })
  filename = "${path.module}/helm-values.yml.tmp"
}

# prometheus
resource "helm_release" "grafana" {
  name          = "grafana"
  chart         = "grafana"
  repository    = "https://grafana.github.io/helm-charts"
  timeout       = "300"
  wait_for_jobs = true
  values        = [
    local_file.grafana-helm-values.content
  ]
}