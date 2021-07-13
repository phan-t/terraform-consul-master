module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "17.1.0"

  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = var.vpc_id
  subnets                         = var.private_subnets
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
      additional_security_group_ids = var.workers_mgmt_security_group_id
    }
  ]
}