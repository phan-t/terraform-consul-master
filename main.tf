locals {
  deployment_id           = lower("${var.deployment_name}-${random_string.suffix.result}")
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "local_file" "consul-ent-license" {
  content  = var.consul_ent_license
  filename = "${path.root}/consul-ent-license.hclic"
}

// HashiCorp Cloud Platform (HCP) infrastructure

module "hcp-hvn" {
  source = "./modules/infra/hcp"

  region                     = var.aws_region
  deployment_id              = local.deployment_id
  cidr                       = var.hcp_hvn_cidr
  aws_vpc_cidr               = var.aws_vpc_cidr
  aws_tgw_id                 = module.infra-aws.tgw_id
  aws_ram_resource_share_arn = module.infra-aws.ram_resource_share_arn
}

// Amazon Web Services (AWS) infrastructure

module "infra-aws" {
  source  = "./modules/infra/aws"
  
  region                      = var.aws_region
  owner                       = var.owner
  ttl                         = var.ttl
  deployment_id               = local.deployment_id
  key_pair_key_name           = var.aws_key_pair_key_name
  vpc_cidr                    = var.aws_vpc_cidr
  public_subnets              = var.aws_public_subnets
  private_subnets             = var.aws_private_subnets
  eks_cluster_version         = var.aws_eks_cluster_version
  eks_cluster_service_cidr    = var.aws_eks_cluster_service_cidr
  eks_worker_instance_type    = var.aws_eks_worker_instance_type
  eks_worker_desired_capacity = var.aws_eks_worker_desired_capacity
  hcp_hvn_provider_account_id = module.hcp-hvn.provider_account_id
  hcp_hvn_cidr                = var.hcp_hvn_cidr
  consul_serf_lan_port        = var.consul_serf_lan_port
}

// Google Cloud Platform (GCP) infrastructure

module "infra-gcp" {
  source  = "./modules/infra/gcp"
  
  region                   = var.gcp_region
  project_id               = var.gcp_project_id
  deployment_id            = local.deployment_id
  private_subnets          = var.gcp_private_subnets
  gke_pod_subnet           = var.gcp_gke_pod_subnet
  gke_cluster_service_cidr = var.gcp_gke_cluster_service_cidr
}

// Consul datacenter (primary) in AWS

module "consul-server-aws" {
  source    = "./modules/consul/aws/consul"
  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
   }

  deployment_name     = var.deployment_name
  cluster_id          = module.infra-aws.eks_cluster_id
  helm_chart_version  = var.consul_helm_chart_version
  consul_version      = var.consul_version
  consul_ent_license  = var.consul_ent_license
  serf_lan_port       = var.consul_serf_lan_port
  replicas            = var.consul_replicas

  depends_on = [
    module.infra-aws
  ]
}

// Consul datacenter (secondary) in GCP

module "consul-server-gcp" {
  source = "./modules/consul/gcp/consul"
  providers = {
    kubernetes = kubernetes.gke
    helm       = helm.gke
   }

  deployment_name         = var.deployment_name
  helm_chart_version      = var.consul_helm_chart_version
  federation_secret       = module.consul-server-aws.federation_secret
  consul_version          = var.consul_version
  consul_ent_license      = var.consul_ent_license
  serf_lan_port           = var.consul_serf_lan_port
  replicas                = var.consul_replicas
  primary_datacenter_name = module.consul-server-aws.primary_datacenter_name
  cluster_api_endpoint    = module.infra-gcp.cluster_api_endpoint

  depends_on = [
    module.infra-gcp
  ]
}

// Consul-Terraform-Sync in AWS

module "cts-aws" {
  source = "./modules/consul/aws/cts"
  count  = var.enable_cts_aws ? 1 : 0

  owner                 = var.owner
  ttl                   = var.ttl
  deployment_name       = var.deployment_name
  key_pair_key_name     = var.aws_key_pair_key_name
  private_subnet_ids    = module.infra-aws.private_subnet_ids
  security_group_ssh_id = module.infra-aws.security_group_ssh_id
  bastion_public_fqdn   = module.infra-aws.bastion_public_fqdn
  server_private_fqdn   = module.consul-server-aws.private_fqdn
  serf_lan_port         = var.consul_serf_lan_port
}

// Prometheus and Grafana in AWS

module "prometheus" {
  source = "./modules/prometheus/aws/prometheus"

  consul_acl_token_secret = module.consul-server-aws.prometheus_acl_token_secret

  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
   }

  depends_on = [
    module.consul-server-aws
  ]
}

module "grafana" {
  source = "./modules/grafana/aws/grafana"

  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
   }
   
  depends_on = [
    module.prometheus
  ]
}

// HCP Vault

module "hcp-vault" {
  source = "./modules/vault/hcp"

  deployment_id = local.deployment_id
  hcp_hvn_id    = module.hcp-hvn.id
  tier          = var.hcp_vault_tier
}

// HCP Boundary

module "hcp-boundary" {
  source = "./modules/boundary/hcp"

  deployment_id = local.deployment_id
  init_user     = var.hcp_boundary_init_user
  init_pass     = var.hcp_boundary_init_pass
}

# module "hashicups-multi-cloud" {
#   source = "./modules/hashicups/multi-cloud"

#   owner                                           = var.owner
#   ttl                                             = var.ttl
#   deployment_name                                 = var.deployment_name
#   aws_key_pair_key_name                           = var.aws_key_pair_key_name
#   aws_private_subnet_ids                          = module.infra-aws.private_subnet_ids
#   aws_security_group_allow_ssh_inbound_id         = module.infra-aws.security_group_allow_ssh_inbound_id
#   aws_security_group_allow_any_private_inbound_id = module.infra-aws.security_group_allow_any_private_inbound_id
#   aws_bastion_public_fqdn                         = module.infra-aws.bastion_public_fqdn
#   consul_server_private_fqdn                      = module.consul-server-aws.private_fqdn
#   consul_serf_lan_port                            = var.consul_serf_lan_port
#   gcp_project_id                                  = var.gcp_project_id
#   gcp_vpc_name                                    = module.infra-gcp.vpc_name
# }