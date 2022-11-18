output "public_endpoint_url" {
  description = "HCP boundary public url"
  value = hcp_boundary_cluster.boundary.cluster_url
}