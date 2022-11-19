terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.43.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.0"
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

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

data "aws_eks_cluster" "cluster" {
  name = module.infra-aws.eks_cluster_id
}

provider "kubernetes" {
  alias = "eks"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
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

data "google_client_config" "default" {}

data "google_container_cluster" "cluster" {
  name     = local.deployment_id
  location = var.gcp_region
}

provider "kubernetes" {
  alias = "gke"
  host  = module.infra-gcp.cluster_api_endpoint
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.infra-gcp.cluster_ca_certificate)
}

provider "helm" {
  alias = "gke"
  kubernetes {
    host  = module.infra-gcp.cluster_api_endpoint
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.infra-gcp.cluster_ca_certificate)
  }
}

provider "consul" {
  address        = "https://${module.consul-server-aws.ui_public_fqdn}"
  scheme         = "https"
  datacenter     = "${var.deployment_name}-aws"
  token          = module.consul-server-aws.bootstrap_acl_token
  insecure_https = true
}