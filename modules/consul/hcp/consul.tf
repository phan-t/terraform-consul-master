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

resource "local_file" "k8s-root-roken" {
  content  = hcp_consul_cluster_root_token.token.kubernetes_secret
  filename = "${path.module}/k8s-root-token.yml.tmp"
}

data "hcp_consul_agent_kubernetes_secret" "consul" {
  cluster_id = hcp_consul_cluster.consul.cluster_id
}

resource "local_file" "k8s-client-secrets" {
  content  = data.hcp_consul_agent_kubernetes_secret.consul.secret
  filename = "${path.module}/k8s-client-secrets.yml.tmp"
}

// consul admin partitions

resource "consul_admin_partition" "hashicups" {
  name        = "hashicups"
  description = "Partition for hashicups team"

  depends_on = [
    hcp_consul_cluster.consul
  ]
}

resource "local_file" "client-partition-frontend-helm-values" {
  content = templatefile("${path.root}/examples/templates/consul-client-partition-helm.yml", {
    partition_name          = consul_admin_partition.hashicups.name
    deployment_name         = "${var.deployment_name}-hcp"
    consul_version          = var.min_version
    server_private_fqdn     = trimprefix(hcp_consul_cluster.consul.consul_private_endpoint_url, "https://")
    kubernetes_api_endpoint = var.kubernetes_api_endpoint
    replicas                = var.replicas
    cloud                   = "aws"
    })
  filename = "${path.module}/k8s-client-partition-frontend-helm-values.yml.tmp"
}