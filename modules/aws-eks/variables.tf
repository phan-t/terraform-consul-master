variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list
}

variable "worker_instance_type" {
  description = "EC2 worker node instance type"
  type        = string
  default     = "t2.small"
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

variable "workers_mgmt_security_group_id" {
  description = "EKS workers management security group id"
  type        = list(string)
  default     = []
}