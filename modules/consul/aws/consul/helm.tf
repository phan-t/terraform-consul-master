# consul client
resource "helm_release" "consul-client" {
  name          = "${var.deployment_name}-consul-client"
  chart         = "consul"
  repository    = "https://helm.releases.hashicorp.com"
  version       = var.helm_chart_version
  namespace     = "consul"
  timeout       = "300"
  wait_for_jobs = true
  values        = [
    var.client_helm_values
  ]

  depends_on    = [
    kubernetes_namespace.consul
  ]
}