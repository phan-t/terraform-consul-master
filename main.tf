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
  
  region            = var.aws_region
  owner             = var.owner
  ttl               = var.ttl
  deployment_name   = var.deployment_name
  vpc_cidr          = var.aws_vpc_cidr
  private_subnets   = var.aws_private_subnets
  public_subnets    = var.aws_public_subnets
  cluster_name      = local.aws_eks_cluster_name
  cluster_version   = var.aws_eks_cluster_version
  key_pair_key_name = var.aws_key_pair_key_name
}

module "eks-helm" {
  source = "./modules/consul/eks-helm"

  deployment_name     = var.deployment_name
  cluster_id          = module.aws.cluster_id
  workers_asg_arns_id = tolist([module.aws.workers_asg_arns_id])
}