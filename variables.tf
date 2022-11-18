// Generic variables

variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
  default     = ""
}

// HashiCorp identification variables

variable "owner" {
  description = "Resource owner identified using an email address"
  type        = string
  default     = ""
}

variable "ttl" {
  description = "Resource TTL (time-to-live)"
  type        = number
  default     = 48
}

// Enable & disable modules

variable "enable_cts_aws" {
  description = "Deploy Consul-Terraform-Sync node in Amazon Web Services (AWS)"
  type        = bool
  default     = false
}

// HashiCorp Cloud Platform (HCP) variables

variable "hcp_region" {
  description = "HCP region"
  type        = string
  default     = ""
}

variable "hcp_client_id" {
  description = "HCP client id"
  type        = string
  default     = ""
}

variable "hcp_client_secret" {
  description = "HCP client secret"
  type        = string
  default     = ""
}

variable "hcp_hvn_cidr" {
  description = "HCP HVN cidr"
  type        = string
  default     = "172.25.16.0/20"
}

variable "hcp_vault_tier" {
  description = "HCP Vault cluster tier"
  type        = string
  default     = "dev"
}

variable "hcp_boundary_init_user" {
  description = "Initial admin user"
  type        = string
  default     = "admin"
}

variable "hcp_boundary_init_pass" {
  description = "Initial admin user password"
  type        = string
  default     = "HashiCorp1!"
}

// Amazon Web Services (AWS) variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "aws_key_pair_key_name" {
  description = "Key pair name"
  type        = string
  default     = ""
}

variable "aws_vpc_cidr" {
  description = "AWS VPC CIDR"
  type        = string
  default     = "10.200.0.0/16"
}

variable "aws_private_subnets" {
  description = "AWS private subnets"
  type        = list
  default     = ["10.200.20.0/24", "10.200.21.0/24", "10.200.22.0/24"]
}

variable "aws_public_subnets" {
  description = "AWS public subnets"
  type        = list
  default     = ["10.200.10.0/24", "10.200.11.0/24", "10.200.12.0/24"]
}

variable "aws_eks_cluster_version" {
  description = "AWS EKS cluster version"
  type        = string
  default     = "1.22"
}

variable "aws_eks_cluster_service_cidr" {
  description = "AWS EKS cluster service cidr"
  type        = string
  default     = "172.20.0.0/18"
}

variable "aws_eks_worker_instance_type" {
  description = "EC2 worker node instance type"
  type        = string
  default     = "m5.large"
}

variable "aws_eks_worker_desired_capacity" {
  description = "Desired worker capacity in the autoscaling group"
  type        = number
  default     = 2
}

// Google Cloud Platform (GCP) variables

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = ""
}

variable "gcp_project_id" {
  description = "GCP project id"
  type        = string
  default     = ""
}

variable "gcp_private_subnets" {
  description = "GCP private subnets"
  type        = list
  default     = ["10.210.20.0/24", "10.210.21.0/24", "10.210.22.0/24"]
}

variable "gcp_gke_pod_subnet" {
  description = "GCP GKE pod subnet"
  type        = string
  default     = "10.211.20.0/23"
}

variable "gcp_gke_cluster_service_cidr" {
  description = "GCP GKE cluster service cidr"
  type        = string
  default     = "172.20.0.0/18"
}

// HashiCorp Consul variables

variable "consul_helm_chart_version" {
  type        = string
  description = "Helm chart version"
  default     = "0.49.1"
}

variable "consul_version" {
  description = "Consul version"
  type        = string
  default     = "1.13.3-ent"
}

variable "consul_ent_license" {
  description = "Consul enterprise license"
  type        = string
  default     = ""
}

variable "consul_replicas" {
  description = "Number of Consul replicas"
  type        = number
  default     = 1
}

variable "consul_serf_lan_port" {
  description = "Consul serf lan port"
  type        = number
  default     = 9301
}

// Fake-service variables

variable "ami_fake_service" {
  description = "AMI of fake-service"
  type        = string
  default     = "ami-075f2e577e993d4ea"
}