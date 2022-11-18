resource "hcp_boundary_cluster" "boundary" {
  cluster_id = var.deployment_id
  username   = var.init_user
  password   = var.init_pass
}