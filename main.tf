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
  consul_serf_lan_port        = var.consul_serf_lan_port
}

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

module "prometheus" {
  source = "./modules/prometheus/aws/prometheus"

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

# module "infra-gcp" {
#   source  = "./modules/infra/gcp"
  
#   region                = var.gcp_region
#   project_id            = var.gcp_project_id
#   deployment_id         = local.deployment_id
#   cluster_service_cidr  = var.gcp_gke_cluster_service_cidr
# }

# module "consul-server-gcp" {
#   source = "./modules/consul/gcp/consul"
#   providers = {
#     kubernetes = kubernetes.gke
#     helm       = helm.gke
#    }

#   deployment_name         = var.deployment_name
#   helm_chart_version      = var.consul_helm_chart_version
#   federation_secret       = module.consul-server-aws.federation_secret
#   consul_version          = var.consul_version
#   consul_ent_license      = var.consul_ent_license
#   serf_lan_port           = var.consul_serf_lan_port
#   replicas                = var.consul_replicas
#   primary_datacenter_name = module.consul-server-aws.primary_datacenter_name
#   cluster_api_endpoint    = module.infra-gcp.cluster_api_endpoint

#   depends_on = [
#     module.infra-gcp
#   ]
# }

# module "boundary-aws-infra" {
#   source = "./modules/boundary/aws/infra"

#   owner                                       = var.owner
#   ttl                                         = var.ttl
#   deployment_name                             = var.deployment_name
#   deployment_id                               = local.deployment_id
#   key_pair_key_name                           = var.aws_key_pair_key_name
#   vpc_id                                      = module.infra-aws.vpc_id
#   public_subnets_cidr_blocks                  = var.aws_public_subnets
#   public_subnet_ids                           = module.infra-aws.public_subnet_ids
#   security_group_allow_ssh_inbound_id         = module.infra-aws.security_group_allow_ssh_inbound_id
# }

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

# module "fake-services" {
#   source = "./modules/fake-services/aws"

#   owner                              = var.owner
#   ttl                                = var.ttl
#   key_pair_key_name                  = var.aws_key_pair_key_name
#   datacenter_config                  = var.datacenter_config
#   public_subnet_ids                  = module.infra-aws.vpc_public_subnet_ids
#   security_group_ssh_id              = module.infra-aws.sg_ssh_ids
#   security_group_consul_id           = module.infra-aws.sg_consul_ids
#   security_group_fake_service_id     = module.infra-aws.sg_fake_service_ids
#   consul_server_private_fqdn         = module.consul-server-aws.private_fqdn
#   consul_serf_lan_port               = var.consul_serf_lan_port
#   ami_fake_service                   = var.ami_fake_service
# }