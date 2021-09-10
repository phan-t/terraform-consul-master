provider "aws" {
  region = var.aws_region
  /*default_tags {
    tags = {
      owner = var.owner
      TTL = var.ttl
    }
  }*/
}

locals {
  deployment_id = "${var.deployment_name}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "aws-infra" {
  source  = "./modules/infra/aws"
  
  region                = var.aws_region
  owner                 = var.owner
  ttl                   = var.ttl
  deployment_id         = local.deployment_id
  key_pair_key_name     = var.aws_key_pair_key_name
  vpc_cidr              = var.aws_vpc_cidr
  public_subnets        = var.aws_public_subnets
  private_subnets       = var.aws_private_subnets
}

module "consul-aws-server" {
  source = "./modules/consul/aws/infra"

  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_name                             = var.deployment_name
  deployment_id                               = local.deployment_id
  key_pair_key_name                           = var.aws_key_pair_key_name
  vpc_id                                      = module.aws-infra.vpc_id
  private_subnet_ids                          = module.aws-infra.private_subnet_ids
  security_group_allow_any_private_inbound_id = module.aws-infra.security_group_allow_any_private_inbound_id
  security_group_allow_ssh_inbound_id         = module.aws-infra.security_group_allow_ssh_inbound_id
  cluster_version                             = var.aws_eks_cluster_version
  worker_instance_type                        = var.aws_eks_worker_instance_type
  asg_desired_capacity                        = var.aws_eks_asg_desired_capacity
  consul_version                              = var.consul_version
  serf_lan_port                               = var.consul_serf_lan_port
  replicas                                    = var.consul_replicas
}

module "cts-aws" {
  source = "./modules/consul/aws/cts"

  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_name                             = var.deployment_name
  key_pair_key_name                           = var.aws_key_pair_key_name
  private_subnet_ids                          = module.aws-infra.private_subnet_ids
  security_group_allow_any_private_inbound_id = module.aws-infra.security_group_allow_any_private_inbound_id
  security_group_allow_ssh_inbound_id         = module.aws-infra.security_group_allow_ssh_inbound_id
  bastion_public_fqdn                         = module.aws-infra.bastion_public_fqdn
  server_private_fqdn                         = module.consul-aws-server.private_fqdn
  serf_lan_port                               = var.consul_serf_lan_port
}

module "boundary-aws-infra" {
  source = "./modules/boundary/aws/infra"

  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_name                             = var.deployment_name
  deployment_id                               = local.deployment_id
  key_pair_key_name                           = var.aws_key_pair_key_name
  vpc_id                                      = module.aws-infra.vpc_id
  public_subnets_cidr_blocks                  = var.aws_public_subnets
  public_subnet_ids                           = module.aws-infra.public_subnet_ids
  security_group_allow_ssh_inbound_id         = module.aws-infra.security_group_allow_ssh_inbound_id
}