variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
  default     = "tphan-test"
}

variable "owner" {
  description = "Resource owner identified using an email address"
  type        = string
  default     = "tphan@hashicorp.com"
}

variable "ttl" {
  description = "Resource TTL (time-to-live)"
  type        = number
  default     = 48
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "aws_key_pair_key_name" {
  description = "Key pair name"
  type        = string
  default     = "tphan"
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
  default     = "1.20"
}

variable "consul_serf_lan_port" {
  description = "Consul serf lan port"
  type        = string
  default     = "9301"
}