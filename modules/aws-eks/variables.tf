variable "vpc_id" {
  description = "AWS VPC id"
  type        = string
}

variable "private_subnets" {
  description = "AWS private subnets"
  type        = list
}

variable "eks_workers_mgmt_security_group_id" {
  description = "AWS EKS workers management security group id"
  type        = list(string)
  default     = []
}

variable "eks_cluster_name" {
  description = "AWS EKS cluster name"
  type        = string
}