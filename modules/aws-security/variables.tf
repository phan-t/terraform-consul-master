variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "vpc_id" {
  description = "AWS VPC id"
  type        = string
}

variable "allow-subnets-eks-workers-mgmt" {
  description = "Allow source subnets for EKS workers management"
  type        = list
}