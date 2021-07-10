resource "aws_security_group" "eks-workers-mgmt" {
  name_prefix = "${var.deployment_name}-eks-workers-mgmt"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = var.allow-subnets-eks-workers-mgmt
  }
}