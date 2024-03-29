module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.26.3"

  cluster_name                    = var.deployment_id
  cluster_version                 = var.eks_cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = true
  cluster_service_ipv4_cidr       = var.eks_cluster_service_cidr

  eks_managed_node_group_defaults = { 
  }

  eks_managed_node_groups = {
    "default_node_group" = {
      min_size               = 1
      max_size               = 3
      desired_size           = var.eks_worker_desired_capacity

      instance_types         = ["${var.eks_worker_instance_type}"]
      key_name               = var.key_pair_key_name
      vpc_security_group_ids = [module.sg-consul.security_group_id]
    }
  }
  
  tags = {
    owner = var.owner
    TTL   = var.ttl
  }
}

resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_id}"
  }

  depends_on = [
    module.eks
  ]
}