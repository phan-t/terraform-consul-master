# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

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
  filename = "${path.module}/consul-federation-secret.json"
}

resource "kubernetes_secret" "consul-ent-license" {
  metadata {
    name = "consul-ent-license"
  }

  data = {
    key = var.consul_ent_license
  }
}