resource "aws_security_group" "allow-boundary-controller-public-inbound" {
  name_prefix = "${var.deployment_id}-allow_boundary_controller_inbound-"
  description = "Allow boundary controller public inbound"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9200
    to_port     = 9201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-boundary-worker-public-inbound" {
  name_prefix = "${var.deployment_id}-allow_boundary_worker_inbound-"
  description = "Allow boundary controller public inbound"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9202
    to_port     = 9202
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-boundary-db-inbound" {
  name_prefix = "${var.deployment_id}-allow_boundary_controller_inbound-"
  description = "Allow boundary db inbound"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.public_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}