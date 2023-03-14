locals {
  deployment_id = lower("${var.deployment_name}-${random_string.suffix.result}")
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "local_file" "consul-ent-license" {
  content  = var.consul_ent_license
  filename = "${path.root}/consul-ent-license.hclic"
}

// hashicorp cloud platform (hcp) infrastructure

module "hcp-hvn" {
  source = "./modules/infra/hcp"

  region                     = var.aws_region
  deployment_id              = local.deployment_id
  cidr                       = var.hcp_hvn_cidr
  aws_vpc_cidr               = var.aws_vpc_cidr
  aws_tgw_id                 = module.infra-aws.tgw_id
  aws_ram_resource_share_arn = module.infra-aws.ram_resource_share_arn
}

// amazon web services (aws) infrastructure

module "infra-aws" {
  source  = "./modules/infra/aws"
  
  region                      = var.aws_region
  owner                       = var.owner
  ttl                         = var.ttl
  deployment_id               = local.deployment_id
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

// google cloud platform (gcp) infrastructure

module "infra-gcp" {
  source  = "./modules/infra/gcp"
  
  region                   = var.gcp_region
  project_id               = var.gcp_project_id
  deployment_id            = local.deployment_id
  private_subnets          = var.gcp_private_subnets
  gke_pod_subnet           = var.gcp_gke_pod_subnet
  gke_cluster_service_cidr = var.gcp_gke_cluster_service_cidr
}

// hcp consul

module "hcp-consul" {
  source = "./modules/consul/hcp"
  providers = {
    consul     = consul.hcp
   }

  deployment_name         = var.deployment_name
  hvn_id                  = module.hcp-hvn.id
  tier                    = var.hcp_consul_tier
  min_version             = var.consul_version
  replicas                = var.consul_replicas
  kubernetes_api_endpoint = data.aws_eks_cluster.cluster.endpoint
}

// hcp vault

module "hcp-vault" {
  source = "./modules/vault/hcp"

  deployment_name = var.deployment_name
  hvn_id          = module.hcp-hvn.id
  tier            = var.hcp_vault_tier
}

// hcp boundary

module "hcp-boundary" {
  source = "./modules/boundary/hcp"

  deployment_name = var.deployment_name
  init_user       = var.hcp_boundary_init_user
  init_pass       = var.hcp_boundary_init_pass
}

// consul datacenter in gcp

module "consul-server-gcp" {
  source = "./modules/consul/gcp/consul"
  providers = {
    kubernetes = kubernetes.gke
    helm       = helm.gke
    consul     = consul.gcp
   }

  deployment_name       = var.deployment_name
  helm_chart_version    = var.consul_helm_chart_version
  consul_version        = "${var.consul_version}-ent"
  consul_ent_license    = var.consul_ent_license
  serf_lan_port         = var.consul_serf_lan_port
  replicas              = var.consul_replicas
  # default_peering_token = module.consul-client-aws.default_peering_token

  depends_on = [
    module.infra-gcp
  ]
}

// consul client (default partition) in aws

module "consul-client-aws" {
  source    = "./modules/consul/aws/consul"
  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
    consul     = consul.hcp
   }
  deployment_name    = var.deployment_name
  helm_chart_version = var.consul_helm_chart_version
  bootstrap_token    = module.hcp-consul.bootstrap_token
  gossip_encrypt_key = module.hcp-consul.gossip_encrypt_key
  client_ca_cert     = module.hcp-consul.client_ca_cert
  client_helm_values = module.hcp-consul.client_default_partition_helm_values

  depends_on = [
    module.infra-aws
  ]
}

# // consul-terraform-sync instance in aws

# module "cts-aws" {
#   source = "./modules/consul/aws/cts"
#   count  = var.enable_cts_aws ? 1 : 0

#   owner                 = var.owner
#   ttl                   = var.ttl
#   deployment_name       = var.deployment_name
#   ami                   = var.aws_ami_consul_terraform_sync
#   key_pair_key_name     = var.aws_key_pair_key_name
#   private_subnet_ids    = module.infra-aws.private_subnet_ids
#   security_group_ssh_id = module.infra-aws.security_group_ssh_id
#   bastion_public_fqdn   = module.infra-aws.bastion_public_fqdn
#   server_private_fqdn   = module.consul-server-aws.private_fqdn
#   serf_lan_port         = var.consul_serf_lan_port
# }

# // prometheus and grafana on aws eks

# module "prometheus" {
#   source = "./modules/prometheus/aws/prometheus"

#   consul_acl_token_secret = module.consul-server-aws.prometheus_acl_token_secret

#   providers = {
#     kubernetes = kubernetes.eks
#     helm       = helm.eks
#    }

#   depends_on = [
#     module.consul-server-aws
#   ]
# }

# module "grafana" {
#   source = "./modules/grafana/aws/grafana"

#   providers = {
#     kubernetes = kubernetes.eks
#     helm       = helm.eks
#    }
   
#   depends_on = [
#     module.prometheus
#   ]
# }

// hashicups multi-cloud

# module "hashicups-multi-cloud" {
#   source = "./modules/hashicups/multi-cloud"
#   providers = {
#     consul.aws = consul.aws
#     consul.gcp = consul.gcp
#    }

#   owner                         = var.owner
#   ttl                           = var.ttl
#   deployment_name               = var.deployment_name
#   ami                           = var.aws_ami_hashicups_product_api_db
#   aws_key_pair_key_name         = var.aws_key_pair_key_name
#   aws_private_subnet_ids        = module.infra-aws.private_subnet_ids
#   aws_security_group_ssh_id     = module.infra-aws.security_group_ssh_id
#   aws_security_group_consul_id  = module.infra-aws.security_group_consul_id
#   aws_bastion_public_fqdn       = module.infra-aws.bastion_public_fqdn
#   consul_server_private_fqdn    = module.consul-server-aws.private_fqdn
#   consul_serf_lan_port          = var.consul_serf_lan_port
#   gcp_project_id                = var.gcp_project_id
#   gcp_vpc_name                  = module.infra-gcp.vpc_name
# }