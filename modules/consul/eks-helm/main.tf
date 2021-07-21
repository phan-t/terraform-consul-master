provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "consul" {
  name          = "${var.deployment_name}-consul"
  chart         = "consul"
  repository    = "https://helm.releases.hashicorp.com"
  version       = "0.32.1"
  depends_on    = [
    var.cluster_iam_role_arn,
    var.workers_asg_arns_id,
    var.private_route_table_association_ids, 
    var.public_route_table_association_ids, 
    var.private_nat_gateway_route_ids, 
    var.public_internet_gateway_route_id
  ]

  set {
    name  = "global.enabled"
    value = true
  }

  set {
    name  = "global.name"
    value = "consul"
  }

  set {
    name  = "global.image"
    value = "consul:1.10.0"
  }

  set {
    name  = "global.datacenter"
    value = "${var.deployment_name}-aws"
  }

  set {
    name  = "global.tls.enabled"
    value = true
  }

  set {
    name  = "global.tls.enableAutoEncrypt"
    value = true
  }

  set {
    name  = "server.replicas"
    value = var.replicas
  }

  set {
    name  = "server.bootstrapExpect"
    value = var.replicas
  }

  set {
    name  = "server.exposeGossipAndRPCPorts"
    value = true
  }

    set {
    name  = "server.ports.serflan.port"
    value = 9301
  }

  set {
    name  = "ui.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "syncCatalog.enabled"
    value = true
  }

  set {
    name  = "connectInject.enabled"
    value = true
  }

  set {
    name  = "controller.enabled"
    value = true
  }
}

