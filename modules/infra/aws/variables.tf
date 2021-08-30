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

variable "key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "consul_server_fqdn" {
  description = "Consul server node fqdn"
  type        = string
}

variable "consul_serf_lan_port" {
  description = "Consul serf lan port"
  type        = string
}