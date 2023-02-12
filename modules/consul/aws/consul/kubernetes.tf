data "kubernetes_service" "consul-ingress-gateway" {
  metadata {
    name = "consul-aws-ingress-gateway"
    namespace = "consul"
  }

  depends_on = [
    helm_release.consul-client
  ]
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

resource "kubernetes_secret" "consul-bootstrap-token" {
  metadata {
    name      = "tphan-test-hcp-bootstrap-token"
    namespace = "consul"
  }

  data = {
    token = var.bootstrap_token
  }
}

resource "kubernetes_secret" "consul-client-secrets" {
  metadata {
    name      = "tphan-test-hcp-client-secrets"
    namespace = "consul"
  }

  data = {
    gossipEncryptionKey = var.gossip_encrypt_key
    caCert              = var.client_ca_cert
  }
}

// set consul default partition cluster peering through mesh gateways via kubernetes custom resource definition (crd), terraform resource consul_config_entry is not working, needs investigation.

resource "kubernetes_manifest" "eks-consul-mesh" {
  manifest = yamldecode(file("${path.root}/examples/manifests/consul_mesh_peering_mesh_gateway.yml"))
}