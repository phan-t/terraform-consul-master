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

variable "deployment_id" {
  description = "Deployment id"
  type        = string
}

variable "key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "cluster_service_cidr" {
  description = "EKS cluster service cidr"
  type        = string
}

variable "worker_instance_type" {
  description = "EC2 worker node instance type"
  type        = string
}

variable "asg_desired_capacity" {
  description = "Desired worker capacity in the autoscaling group"
  type        = number
}