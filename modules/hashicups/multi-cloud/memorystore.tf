module "memorystore" {
  source         = "terraform-google-modules/memorystore/google"

  name           = "payments-queue"
  project        = var.gcp_project_id
  enable_apis    = "true"
  memory_size_gb = "1"
  tier           = "BASIC"
}