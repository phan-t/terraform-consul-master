variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "cluster_id" {
  description = "EKS cluster id"
  type        = string
}

variable "replicas" {
  description = "Number of Consul replicas"
  type        = number
  default     = 1
}

variable "workers_asg_arns_id" {
  description = "Id of the autoscaling groups containing workers"
  type        = list
}