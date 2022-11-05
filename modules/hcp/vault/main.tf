resource "hcp_vault_cluster" "vault" {
  hvn_id            = var.hcp_hvn_id
  cluster_id        = var.deployment_id
  tier              = var.tier
  public_endpoint   = true
}

resource "hcp_vault_cluster_admin_token" "token" {
  cluster_id = var.deployment_id
}