output "eks_workers_mgmt_security_group_id" {
  description = "EKS workers management security group id"
  value       = aws_security_group.eks-workers-mgmt.id
}