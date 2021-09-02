module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "17.1.0"

  cluster_name                    = var.deployment_id
  cluster_version                 = var.cluster_version
  vpc_id                          = var.vpc_id
  subnets                         = var.private_subnet_ids
  cluster_endpoint_private_access = true

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = var.worker_instance_type
      key_name                      = var.key_pair_key_name
      asg_desired_capacity          = var.asg_desired_capacity
      additional_security_group_ids = [var.security_group_allow_ssh_inbound_id, var.security_group_allow_any_private_inbound_id]
    }
  ]
  
  tags = {
    owner = var.owner
    TTL = var.ttl
  }
}

/*
# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# The Kubernetes provider is included here so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}
*/