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

variable "deployment_id" {
  description = "Deployment id"
  type        = string
}

variable "key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets"
  type        = list
}

variable "security_group_allow_ssh_inbound_id" {
  description = "Security group allow-ssh-inbound id"
  type        = string
}

variable "security_group_allow_any_private_inbound_id" {
  description = "Security group allow-any-private-inbound id"
  type        = string
}

variable "cluster_version" {
  description = "EKS cluster version"
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

variable "consul_version" {
  description = "Version"
  type        = string
}

variable "serf_lan_port" {
  description = "Serf lan port"
  type        = number
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
}