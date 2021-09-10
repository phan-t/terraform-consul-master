/*
variable "region" {
  description = "AWS region"
  type        = string
}

variable "controller_public_fqdn" {
  type        = string
}

variable "kms_recovery_key_id" {
  type        = string
}


variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}
*/

variable "users" {
  type        = set(string)
  default     = [
    "david",
    "ilche",
    "tony"
  ]
}