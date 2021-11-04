resource "local_file" "prometheus-helm-values" {
  content = templatefile("${path.root}/examples/templates/prometheus-helm.yml", {
    })
  filename = "${path.module}/helm-values.yml"
}

# prometheus
resource "helm_release" "prometheus" {
  name          = "prometheus"
  chart         = "prometheus"
  repository    = "https://prometheus-community.github.io/helm-charts"
  timeout       = "300"
  wait_for_jobs = true
  values        = [
    local_file.prometheus-helm-values.content
  ]
}