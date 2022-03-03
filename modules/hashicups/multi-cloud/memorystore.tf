# Enable Redis API service
resource "google_project_service" "project" {
  service                     = "redis.googleapis.com"
  disable_dependent_services  = true
}

module "memorystore" {
  source                  = "terraform-google-modules/memorystore/google"

  name                    = "payments-queue"
  project                 = var.gcp_project_id
  authorized_network      = var.gcp_vpc_name
  enable_apis             = "true"
  memory_size_gb          = "1"
  tier                    = "BASIC"
  transit_encryption_mode	= "DISABLED"
}