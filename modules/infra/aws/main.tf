data "aws_ami" "ubuntu20" {

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners = ["099720109477"]
}

resource "aws_instance" "bastion-node" {
  ami             = data.aws_ami.ubuntu20.id
  instance_type   = "t2.micro"
  key_name        = var.key_pair_key_name
  subnet_id       = element(module.vpc.public_subnets, 1)
  security_groups = [aws_security_group.allow-ssh-public-inbound.id]

  tags = {
    owner = var.owner
    TTL = var.ttl
  }
}

resource "aws_instance" "cts-node" {
  ami             = "ami-0b12537d4e6b1893c"
  instance_type   = "t2.small"
  key_name        = var.key_pair_key_name
  subnet_id       = element(module.vpc.private_subnets, 1)
  security_groups = [aws_security_group.allow-ssh-inbound.id, aws_security_group.allow-any-private-inbound.id]

  tags = {
    owner = var.owner
    TTL = var.ttl
  }
}