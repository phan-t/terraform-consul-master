module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"

  project_id             = var.project_id
  name                   = var.deployment_id
  regional               = true
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = "private-gke-pods"
  ip_range_services      = "private-gke-services"
  create_service_account = true

  node_pools = [
    {
      name                      = "default-node-pool"
      machine_type              = "e2-medium"
      min_count                 = 1
      max_count                 = 2
      auto_repair               = true
      auto_upgrade              = true
    },
  ]
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.deployment_id} --region ${var.region}"
  }

  depends_on = [
    module.gke
  ]
}