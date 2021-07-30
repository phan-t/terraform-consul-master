variable "deployment_name" {
  description = "Deployment name, used to prefix resources"
  type        = string
}

variable "cluster_id" {
  description = "EKS cluster id"
  type        = string
}

variable "replicas" {
  description = "Number of Consul replicas pods"
  type        = number
  default     = 1
}

variable "workers_asg_arns_id" {
  description = "Id of the autoscaling groups containing workers"
  type        = list
}

variable "private_nat_gateway_route_ids" {
  description = "Ids of the private route table association"
  type        = list
}

variable "public_internet_gateway_route_id" {
  description = "Ids of the public route table association"
  type        = list
}

variable "private_route_table_association_ids" {
  description = "Ids of the private route table association"
  type        = list
}

variable "public_route_table_association_ids" {
  description = "Ids of the public route table association"
  type        = list
}

variable "consul_version" {
  description = "Consul version"
  type        = string
}