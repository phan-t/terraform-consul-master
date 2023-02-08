resource "hcp_consul_cluster" "consul" {
  cluster_id          = "${var.deployment_name}-hcp"
  hvn_id              = var.hvn_id
  public_endpoint     = true
  tier                = var.tier
  min_consul_version  = var.min_version
}

resource "hcp_consul_cluster_root_token" "token" {
  cluster_id = hcp_consul_cluster.consul.id
}

data "hcp_consul_agent_kubernetes_secret" "consul" {
  cluster_id = hcp_consul_cluster.consul.cluster_id
}

resource "local_file" "eks-client-default-partition-helm-values" {
  content = templatefile("${path.root}/examples/templates/hcp-consul-client-partition-helm.yml", {
    partition_name                = "default"
    deployment_name               = "${var.deployment_name}-hcp"
    consul_version                = var.min_version
    external_server_private_fqdn  = trimprefix(hcp_consul_cluster.consul.consul_private_endpoint_url, "https://")
    external_server_https_port    = 443
    kubernetes_api_endpoint       = var.kubernetes_api_endpoint
    replicas                      = var.replicas
    cloud                         = "aws"
    })
  filename = "${path.module}/eks-client-default-partition-helm-values.yml.tmp"
}