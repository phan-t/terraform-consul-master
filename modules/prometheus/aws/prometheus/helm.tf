resource "local_file" "prometheus-helm-values" {
  content = templatefile("${path.root}/examples/templates/prometheus-helm.yml", {
    consul_acl_token = var.consul_acl_token_secret
    })
  filename = "${path.module}/helm-values.yml.tmp"
}

# prometheus
resource "helm_release" "prometheus" {
  name          = "prometheus"
  chart         = "prometheus"
  repository    = "https://prometheus-community.github.io/helm-charts"
  namespace     = "consul"
  timeout       = "300"
  wait_for_jobs = true
  values        = [
    local_file.prometheus-helm-values.content
  ]
}