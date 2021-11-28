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

variable "aws_key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "aws_private_subnet_ids" {
  description = "Private subnets"
  type        = list
}

variable "aws_security_group_allow_ssh_inbound_id" {
  description = "Security group allow-ssh-inbound id"
  type        = string
}

variable "aws_security_group_allow_any_private_inbound_id" {
  description = "Security group allow-any-private-inbound id"
  type        = string
}

variable "aws_bastion_public_fqdn" {
  description = "Public fqdn of bastion node"
  type        =  string 
}

variable "consul_server_private_fqdn" {
  description = "Server private fqdn"
  type        = string
}

variable "consul_serf_lan_port" {
  description = "Serf lan port"
  type        = number
}

variable "gcp_project_id" {
  description = "GCP project id"
  type        = string
}

variable "gcp_vpc_name" {
  description = "GCP vpc name"
  type        = string
}