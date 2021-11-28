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