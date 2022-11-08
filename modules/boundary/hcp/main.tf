resource "hcp_boundary_cluster" "boundary" {
  cluster_id = var.deployment_id
  username   = var.username
  password   = var.password
}