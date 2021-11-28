locals {
  deployment_id = lower("${var.deployment_name}-${random_string.suffix.result}")
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "local_file" "consul-ent-license" {
  content = var.consul_ent_license
  filename = "${path.root}/consul-ent-license.hclic"
}

module "infra-aws" {
  source  = "./modules/infra/aws"
  
  region                                      = var.aws_region
  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_id                               = local.deployment_id
  key_pair_key_name                           = var.aws_key_pair_key_name
  vpc_cidr                                    = var.aws_vpc_cidr
  public_subnets                              = var.aws_public_subnets
  private_subnets                             = var.aws_private_subnets
  cluster_version                             = var.aws_eks_cluster_version
  cluster_service_cidr                        = var.aws_eks_cluster_service_cidr
  worker_instance_type                        = var.aws_eks_worker_instance_type
  asg_desired_capacity                        = var.aws_eks_asg_desired_capacity
}

module "consul-server-aws" {
  source = "./modules/consul/aws/consul"
  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
   }

  deployment_name                             = var.deployment_name
  cluster_id                                  = module.infra-aws.cluster_id
  consul_version                              = var.consul_version
  consul_ent_license                          = var.consul_ent_license
  serf_lan_port                               = var.consul_serf_lan_port
  replicas                                    = var.consul_replicas

  depends_on = [
    module.infra-aws
  ]
}

module "cts-aws" {
  source = "./modules/consul/aws/cts"

  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_name                             = var.deployment_name
  key_pair_key_name                           = var.aws_key_pair_key_name
  private_subnet_ids                          = module.infra-aws.private_subnet_ids
  security_group_allow_any_private_inbound_id = module.infra-aws.security_group_allow_any_private_inbound_id
  security_group_allow_ssh_inbound_id         = module.infra-aws.security_group_allow_ssh_inbound_id
  bastion_public_fqdn                         = module.infra-aws.bastion_public_fqdn
  server_private_fqdn                         = module.consul-server-aws.private_fqdn
  serf_lan_port                               = var.consul_serf_lan_port

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

module "boundary-aws-infra" {
  source = "./modules/boundary/aws/infra"

  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_name                             = var.deployment_name
  deployment_id                               = local.deployment_id
  key_pair_key_name                           = var.aws_key_pair_key_name
  vpc_id                                      = module.infra-aws.vpc_id
  public_subnets_cidr_blocks                  = var.aws_public_subnets
  public_subnet_ids                           = module.infra-aws.public_subnet_ids
  security_group_allow_ssh_inbound_id         = module.infra-aws.security_group_allow_ssh_inbound_id
}

module "hashicups-multi-cloud" {
  source = "./modules/hashicups/multi-cloud"

  owner                                           = var.owner
  ttl                                             = var.ttl
  deployment_name                                 = var.deployment_name
  aws_key_pair_key_name                           = var.aws_key_pair_key_name
  aws_private_subnet_ids                          = module.infra-aws.private_subnet_ids
  aws_security_group_allow_any_private_inbound_id = module.infra-aws.security_group_allow_any_private_inbound_id
  aws_security_group_allow_ssh_inbound_id         = module.infra-aws.security_group_allow_ssh_inbound_id
  aws_bastion_public_fqdn                         = module.infra-aws.bastion_public_fqdn
  consul_server_private_fqdn                      = module.consul-server-aws.private_fqdn
  consul_serf_lan_port                            = var.consul_serf_lan_port
  gcp_project_id                                  = var.gcp_project_id
}

module "infra-gcp" {
  source  = "./modules/infra/gcp"
  
  region                                      = var.gcp_region
  project_id                                  = var.gcp_project_id
  deployment_id                               = local.deployment_id
  cluster_service_cidr                        = var.gcp_gke_cluster_service_cidr
}

module "consul-server-gcp" {
  source = "./modules/consul/gcp/consul"
  providers = {
    kubernetes = kubernetes.gke
    helm       = helm.gke
   }

  deployment_name                             = var.deployment_name
  federation_secret                           = module.consul-server-aws.federation_secret
  consul_version                              = var.consul_version
  consul_ent_license                          = var.consul_ent_license
  serf_lan_port                               = var.consul_serf_lan_port
  replicas                                    = var.consul_replicas 

  depends_on = [
    module.infra-gcp
  ]
}

/*
module "web-aws" {
  source = "./modules/consul/aws/web"

  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_name                             = var.deployment_name
  key_pair_key_name                           = var.aws_key_pair_key_name
  private_subnet_ids                          = module.infra-aws.private_subnet_ids
  security_group_allow_any_private_inbound_id = module.infra-aws.security_group_allow_any_private_inbound_id
  security_group_allow_ssh_inbound_id         = module.infra-aws.security_group_allow_ssh_inbound_id
  bastion_public_fqdn                         = module.infra-aws.bastion_public_fqdn
  server_private_fqdn                         = module.consul-server-aws.private_fqdn
  serf_lan_port                               = var.consul_serf_lan_port
}

module "bigip" {
  source                  = "git::https://github.com/f5devcentral/terraform-aws-bigip-module?ref=v0.9.7"

  count                   = 1
  prefix                  = "${var.deployment_name}-f5bigip"
  ec2_key_name            = var.aws_key_pair_key_name
  f5_password             = var.f5bigip_password
  f5_ami_search_name      = "F5 BIGIP-16.1.0* PAYG-Good 25Mbps*"
  mgmt_subnet_ids         = [{ "subnet_id" = module.infra-awsa.public_subnet_ids[0], "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids  = [module.infra-aws.security_group_allow_ssh_inbound_id, module.infra-aws.security_group_allow_f5_mgmt_inbound_id]
}
*/