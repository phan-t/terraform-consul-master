variable "region" {
  description = "GCP region"
  type        = string
}

variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "deployment_id" {
  description = "Deployment id"
  type        = string
}

variable "cluster_service_cidr" {
  description = "GCP GKE cluster service cidr"
  type        = string
}