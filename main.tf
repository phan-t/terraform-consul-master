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
  aws_eks_cluster_name = "${var.deployment_name}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "aws" {
  source  = "./modules/infra/aws"
  
  region                = var.aws_region
  owner                 = var.owner
  ttl                   = var.ttl
  deployment_name       = var.deployment_name
  key_pair_key_name     = var.aws_key_pair_key_name
  vpc_cidr              = var.aws_vpc_cidr
  public_subnets        = var.aws_public_subnets
  private_subnets       = var.aws_private_subnets
  cluster_name          = local.aws_eks_cluster_name
}

module "eks-server" {
  source = "./modules/consul/eks-server"

  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_name                             = var.deployment_name
  key_pair_key_name                           = var.aws_key_pair_key_name
  vpc_id                                      = module.aws.vpc_id
  private_subnet_ids                          = module.aws.private_subnet_ids
  security_group_allow_any_private_inbound_id = module.aws.security_group_allow_any_private_inbound_id
  security_group_allow_ssh_inbound_id         = module.aws.security_group_allow_ssh_inbound_id
  cluster_name                                = local.aws_eks_cluster_name
  cluster_version                             = var.aws_eks_cluster_version
  worker_instance_type                        = var.aws_eks_worker_instance_type
  asg_desired_capacity                        = var.aws_eks_asg_desired_capacity
  consul_version                              = var.consul_version
  consul_serf_lan_port                        = var.consul_serf_lan_port
  consul_replicas                             = var.consul_replicas
}

module "cts-node" {
  source = "./modules/consul/cts-node"

  owner                                       = var.owner
  ttl                                         = var.ttl
  deployment_name                             = var.deployment_name
  key_pair_key_name                           = var.aws_key_pair_key_name
  private_subnet_ids                          = module.aws.private_subnet_ids
  security_group_allow_any_private_inbound_id = module.aws.security_group_allow_any_private_inbound_id
  security_group_allow_ssh_inbound_id         = module.aws.security_group_allow_ssh_inbound_id
  bastion_node_public_fqdn                    = module.aws.bastion_node_public_fqdn
  consul_server_fqdn                          = module.eks-server.consul_server_fqdn
  consul_serf_lan_port                        = var.consul_serf_lan_port
}