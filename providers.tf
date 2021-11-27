terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.67.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.90.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  /*default_tags {
    tags = {
      owner = var.owner
      TTL = var.ttl
    }
  }*/
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

data "aws_eks_cluster" "cluster" {
  name = module.infra-aws.cluster_id
}

provider "kubernetes" {
  alias = "eks"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}