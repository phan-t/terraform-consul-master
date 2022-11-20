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

variable "ami" {
  description = "AMI for ec2 instance"
  type        = string
}

variable "key_pair_key_name" {
  description = "Key pair name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets"
  type        = list
}

variable "security_group_ssh_id" {
  description = "Security group ssh id"
  type        = string
}

variable "bastion_public_fqdn" {
  description = "Public fqdn of bastion node"
  type        =  string 
}

variable "server_private_fqdn" {
  description = "Server private fqdn"
  type        = string
}

variable "serf_lan_port" {
  description = "Serf lan port"
  type        = number
}
