# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}