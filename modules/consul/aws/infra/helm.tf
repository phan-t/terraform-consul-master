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

# consul server
resource "helm_release" "consul-server" {
  name          = "${var.deployment_name}-consul-server"
  chart         = "consul"
  repository    = "https://helm.releases.hashicorp.com"
  version       = "0.32.1"
  timeout       = "300"
  wait_for_jobs = true
  depends_on    = [
    module.eks.cluster_id
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
    value = "hashicorp/consul-enterprise:${var.consul_version}"
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
    name  = "global.federation.enabled"
    value = true
  }
  
  set {
    name  = "global.federation.createFederationSecret"
    value = true
  }

  set {
    name  = "global.metrics.enabled"
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
    name  = "server.enterpriseLicense.secretName"
    value = "consul-ent-license"
  }

    set {
    name  = "server.enterpriseLicense.secretKey"
    value = "key"
  }

  set {
    name  = "server.exposeGossipAndRPCPorts"
    value = true
  }

  set {
    name  = "server.ports.serflan.port"
    value = var.serf_lan_port
  }

  set {
    name  = "ui.service.type"
    value = "LoadBalancer"
  }

/*
  set {
    name  = "ui.metrics.enabled"
    value = true
  }

  set {
    name  = "ui.metrics.provider"
    value = "prometheus"
  }

  set {
    name  = "ui.metrics.baseURL"
    value = "http://prometheus-server"
  }
*/

  set {
    name  = "syncCatalog.enabled"
    value = true
  }

  set {
    name  = "connectInject.enabled"
    value = true
  }
  
  set {
    name  = "connectInject.transparentProxy.defaultEnabled"
    value = true
  }

  set {
    name  = "connectInject.envoyExtraArgs"
    value = "--log-level debug"
  }  

  set {
    name  = "connectInject.metrics.defaultEnableMerging"
    value = true
  }

  set {
    name  = "controller.enabled"
    value = true
  }

  set {
    name  = "meshGateway.enabled"
    value = true
  }

  set {
    name  = "meshGateway.replicas"
    value = var.replicas
  }

  set {
    name  = "ingressGateways.enabled"
    value = true
  }

  set {
    name  = "ingressGateways.defaults.replicas"
    value = var.replicas
  }

  set {
    name  = "ingressGateways.defaults.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "ingressGateways.defaults.service.ports[0].port"
    value = 80
  }

  set {
    name  = "terminatingGateways.enabled"
    value = true
  }

  set {
    name  = "terminatingGateways.defaults.replicas"
    value = var.replicas
  }
/*
  set {
    name  = "prometheus.enabled"
    value = true
  }
*/
}

# prometheus
resource "helm_release" "prometheus" {
  name          = "${var.deployment_name}-prometheus"
  chart         = "prometheus"
  repository    = "https://prometheus-community.github.io/helm-charts"
  timeout       = "300"
  wait_for_jobs = true
  depends_on    = [
    helm_release.consul-server
  ]

  set {
    name  = "alertmanager.enabled"
    value = false
  }

  set {
    name  = "nodeExporter.enabled"
    value = false
  }

  set {
    name  = "pushgateway.enabled"
    value = false
  }
}