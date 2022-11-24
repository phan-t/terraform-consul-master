variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "init_user" {
  description = "Initial admin user"
  type        = string
}

variable "init_pass" {
  description = "Initial admin user password"
  type        = string
}