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

variable "public_subnets_cidr_blocks" {
  description = "Public subnets"
  type        = list
}

variable "public_subnet_ids" {
  description = "Public subnets"
  type        = list
}

variable "security_group_allow_ssh_inbound_id" {
  description = "Security group allow-ssh-inbound id"
  type        = string
}

variable "ami_controller_worker" {
  description = "AMI of controller and worker"
  type        = string
  default     = "ami-0842f0912488e8a1b"
}

variable "tls_disabled" {
  default = true
}

variable "tls_cert_path" {
  default = "/etc/pki/tls/boundary/boundary.cert"
}

variable "tls_key_path" {
  default = "/etc/pki/tls/boundary/boundary.key"
}

variable "kms_type" {
  default = "aws"
}