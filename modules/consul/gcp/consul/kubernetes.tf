data "kubernetes_service" "consul-ui" {
  metadata {
    name = "consul-ui"
  }
  
  depends_on = [
    helm_release.consul-server
  ]
}

resource "kubernetes_secret" "consul-federation-secret" {
  metadata {
    name = "consul-federation"
  }

  data = var.federation_secret
}

resource "kubernetes_secret" "consul-ent-license" {
  metadata {
    name = "consul-ent-license"
  }

  data = {
    key = var.consul_ent_license
  }
}