variable "region" {
  description = "AWS region"
  type        = string
}

variable "owner" {
  description = "Resource owner identified using an email address"
  type        = string
}

variable "ttl" {
  description = "Resource TTL (time-to-live)"
  type        = number
}

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

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "worker_instance_type" {
  description = "EC2 worker node instance type"
  type        = string
  default     = "m4.large"
}

variable "key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "asg_desired_capacity" {
  description = "Desired worker capacity in the autoscaling group"
  type        = number
  default     = 2
}