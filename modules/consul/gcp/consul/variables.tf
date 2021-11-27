variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "consul_version" {
  description = "Version"
  type        = string
}

variable "federation_secret" {
  description = "Federation secret"
  type        = map
}

variable "consul_ent_license" {
  description = "Consul enterprise license"
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