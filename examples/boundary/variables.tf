variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
  default     = "tphan-test"
}

variable "url" {
  default = "http://ec2-3-24-240-217.ap-southeast-2.compute.amazonaws.com:9200"
}

variable "kms_recovery_key_id" {
  default = "8020567b-4f37-43c0-a65c-60f951ea520d"
}

variable "users" {
  type    = set(string)
  default = [
    "david",
    "ilche",
    "tony"
  ]
}

variable "consul_infra_ips" {
  type    = set(string)
  default = [
    "10.200.21.216"
  ]
}