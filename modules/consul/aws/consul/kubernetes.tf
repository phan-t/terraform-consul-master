data "kubernetes_service" "consul-ui" {
  metadata {
    name = "consul-ui"
    namespace = "consul"
  }
  
  depends_on = [
    helm_release.consul-server
  ]
}

data "kubernetes_service" "consul-ingress-gateway" {
  metadata {
    name = "consul-ingress-gateway"
    namespace = "consul"
  }

  depends_on = [
    helm_release.consul-server
  ]
}

data "kubernetes_pod" "consul-server" {
  metadata {
    name = "consul-server-0"
    namespace = "consul"
  }

  depends_on = [
    helm_release.consul-server
  ]
}

data "kubernetes_secret" "consul-federation-secret" {
  metadata {
    name = "consul-federation"
    namespace = "consul"
  }

  depends_on = [
  helm_release.consul-server
  ]
}

data "kubernetes_secret" "consul-bootstrap-acl-token" {
  metadata {
    name = "consul-bootstrap-acl-token"
    namespace = "consul"
  }

  depends_on = [
  helm_release.consul-server
  ]
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name      = "consul"
  }
}  

resource "local_file" "consul-federation-secret" {
  content = jsonencode(data.kubernetes_secret.consul-federation-secret)
  filename = "${path.root}/consul-federation-secret.json.tmp"
}

resource "kubernetes_secret" "consul-ent-license" {
  metadata {
    name      = "consul-ent-license"
    namespace = "consul"
  }

  data = {
    key = var.consul_ent_license
  }
}