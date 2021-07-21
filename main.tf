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
  vpc_cidr              = var.aws_vpc_cidr
  private_subnets       = var.aws_private_subnets
  public_subnets        = var.aws_public_subnets
  cluster_name          = local.aws_eks_cluster_name
  cluster_version       = var.aws_eks_cluster_version
  key_pair_key_name     = var.aws_key_pair_key_name
  consul_server_fqdn    = module.eks-helm.consul_server_fqdn
  consul_serf_lan_port  = var.consul_serf_lan_port
}

module "eks-helm" {
  source = "./modules/consul/eks-helm"

  deployment_name                     = var.deployment_name
  cluster_id                          = module.aws.cluster_id
  cluster_iam_role_arn                = tolist([module.aws.cluster_iam_role_arn])
  workers_asg_arns_id                 = tolist([module.aws.workers_asg_arns_id])
  private_nat_gateway_route_ids       = tolist([module.aws.private_nat_gateway_route_ids])
  public_internet_gateway_route_id    = tolist([module.aws.public_internet_gateway_route_id])
  private_route_table_association_ids = tolist([module.aws.private_route_table_association_ids])
  public_route_table_association_ids  = tolist([module.aws.public_route_table_association_ids])
}