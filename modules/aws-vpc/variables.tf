variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "vpc_cidr" {
  description = "AWS VPC CIDR"
  type        = string
}

variable "private_subnets" {
  description = "AWS private subnets"
  type        = list
}

variable "public_subnets" {
  description = "AWS public subnets"
  type        = list
}

variable "eks_cluster_name" {
  description = "AWS EKS cluster name"
  type        = string
}