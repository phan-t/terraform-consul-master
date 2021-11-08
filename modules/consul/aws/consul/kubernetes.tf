data "kubernetes_service" "consul-ui" {
  metadata {
    name = "consul-ui"
  }
  depends_on = [
    helm_release.consul-server
  ]
}

data "kubernetes_service" "consul-ingress-gateway" {
  metadata {
    name = "consul-ingress-gateway"
  }
  depends_on = [
    helm_release.consul-server
  ]
}

data "kubernetes_pod" "consul-server" {
  metadata {
    name = "consul-server-0"
  }
  depends_on = [
    helm_release.consul-server
  ]
}

data "kubernetes_secret" "consul-federation-secret" {
  metadata {
    name = "consul-federation"
  }
  depends_on = [
  helm_release.consul-server
  ]
}

resource "local_file" "consul-federation-secret" {
  content = jsonencode(data.kubernetes_secret.consul-federation-secret)
  filename = "${path.module}/consul-federation-secret.json.tmp"
}

resource "kubernetes_secret" "consul-ent-license" {
  metadata {
    name = "consul-ent-license"
  }

  data = {
    key = var.consul_ent_license
  }
}