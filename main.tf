provider "aws" {
  region = var.aws_region
/*  default_tags {
    tags = {
      owner = var.owner
      TTL = var.ttl
    }
  } */
}

locals {
  aws_eks_cluster_name = "${var.deployment_name}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "aws-vpc" {
  source            = "./modules/aws-vpc"

  deployment_name   = var.deployment_name
  vpc_cidr          = var.aws_vpc_cidr
  private_subnets   = var.aws_private_subnets
  public_subnets    = var.aws_public_subnets
  eks_cluster_name  = local.aws_eks_cluster_name
}

module "aws-security" {
  source                          = "./modules/aws-security"

  deployment_name                 = var.deployment_name
  vpc_id                          = module.aws-vpc.vpc_id
  allow-subnets-eks-workers-mgmt  = tolist([var.aws_vpc_cidr])
}

module "aws-eks" {
  source                          = "./modules/aws-eks"

  vpc_id                          = module.aws-vpc.vpc_id
  key_pair_key_name               = var.aws_key_pair_key_name
  private_subnets                 = module.aws-vpc.private_subnets
  cluster_name                    = local.aws_eks_cluster_name
  cluster_version                 = var.aws_eks_cluster_version
  workers_mgmt_security_group_id  = tolist([module.aws-security.eks_workers_mgmt_security_group_id])
}

module "aws-consul-helm" {
  source = "./modules/aws-consul-helm"

  deployment_name     = var.deployment_name
  cluster_id          = module.aws-eks.eks_cluster_id
  workers_asg_arns_id = tolist([module.aws-eks.eks_workers_asg_arns_id])
}