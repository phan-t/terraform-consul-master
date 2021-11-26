module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "4.0.1"

  project_id   = var.project_id
  network_name = var.deployment_id

  subnets = [
    {
      subnet_name           = "gke-cluster"
      subnet_ip             = "10.210.21.0/24"
      subnet_region         = var.region
    },
  ]
  secondary_ranges = {
    gke-cluster = [
      {
        range_name    = "private-gke-pods"
        ip_cidr_range = "172.20.64.0/18"
      },
      {
        range_name    = "private-gke-services"
        ip_cidr_range = var.cluster_service_cidr
      },
    ]
  }
}