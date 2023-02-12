data "kubernetes_service" "consul-ui" {
  metadata {
    name = "consul-ui"
    namespace = "consul"
  }
  
  depends_on = [
    helm_release.consul-server
  ]
}

data "kubernetes_secret" "consul-bootstrap-token" {
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

resource "kubernetes_secret" "consul-ent-license" {
  metadata {
    name = "consul-ent-license"
    namespace = "consul"
  }

  data = {
    key = var.consul_ent_license
  }
}

// set consul default partition cluster peering through mesh gateways via kubernetes custom resource definition (crd), terraform resource consul_config_entry is not working, needs investigation.

resource "kubernetes_manifest" "gke-consul-mesh" {
  manifest = yamldecode(file("${path.root}/examples/manifests/consul_mesh_peering_mesh_gateway.yml"))
}