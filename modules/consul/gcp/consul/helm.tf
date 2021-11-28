resource "local_file" "consul-server-helm-values" {
  content = templatefile("${path.root}/examples/templates/consul-server-secondary-helm.yml", {
    deployment_name       = "${var.deployment_name}-gcp"
    consul_version        = var.consul_version
    replicas              = var.replicas
    serf_lan_port         = var.serf_lan_port
    })
  filename = "${path.module}/helm-values.yml.tmp"
}

# consul server
resource "helm_release" "consul-server" {
  name          = "${var.deployment_name}-consul-server"
  chart         = "consul"
  repository    = "https://helm.releases.hashicorp.com"
  version       = "0.32.1"
  timeout       = "300"
  wait_for_jobs = true
  values        = [
    local_file.consul-server-helm-values.content
  ]

  depends_on = [
    kubernetes_secret.consul-ent-license,
    kubernetes_secret.consul-federation-secret
  ]
}