variable "deployment_id" {
  description = "Deployment id"
  type        = string
}

variable "hvn_id" {
  description = "HVN id"
  type        = string
}

variable "tier" {
  description = "Consul cluster tier"
  type        = string
}

variable "min_version" {
  description = "Consul minimum version"
  type        = string
}