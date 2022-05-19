terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.9.0"
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
  address        = "https://${module.consul-server-gcp.ui_public_ip}"
  datacenter     = "${var.deployment_name}-gcp"
  scheme         = "https"
  insecure_https = true
}