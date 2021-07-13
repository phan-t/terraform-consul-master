variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}