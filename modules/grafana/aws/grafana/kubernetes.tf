# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = var.cluster_id
}

data "kubernetes_service" "grafana" {
  metadata {
    name = "grafana"
  }
  depends_on = [
    helm_release.grafana
  ]
}