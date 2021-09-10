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

variable "key_pair_key_name" {
  description = "Key pair name"
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

variable "bastion_public_fqdn" {
  description = "Public fqdn of bastion node"
  type        =  string 
}

variable "consul_server_fqdn" {
  description = "Consul server node fqdn"
  type        = string
}

variable "consul_serf_lan_port" {
  description = "Consul serf lan port"
  type        = number
}
