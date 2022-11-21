resource "hcp_consul_cluster" "consul" {
  cluster_id          = var.deployment_id
  hvn_id              = var.hvn_id
  public_endpoint     = true
  tier                = var.tier
  min_consul_version  = var.min_version
}

resource "hcp_consul_cluster_root_token" "token" {
  cluster_id = hcp_consul_cluster.consul.id
}
