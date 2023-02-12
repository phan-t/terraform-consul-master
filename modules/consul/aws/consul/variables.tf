variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "helm_chart_version" {
  type        = string
  description = "Helm chart version"
}

variable "bootstrap_token" {
  description = "ACL bootstrap token"
  type        = string
}

variable "gossip_encrypt_key" {
  description = "Gossip encryption key"
  type        = string
}

variable "client_ca_cert" {
  description = "Client ca certificate"
  type        = string
}

variable "client_helm_values" {
  description = "Client default partition helm values"
}