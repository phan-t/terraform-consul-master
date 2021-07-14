resource "aws_security_group" "workers-mgmt" {
  name_prefix = "${var.deployment_name}-workers-mgmt"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = tolist([var.vpc_cidr])
  }
}