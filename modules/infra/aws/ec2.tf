locals {
  key_pair_private_key = file("${path.root}/tphan-hashicorp-aws.pem")
}

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

resource "aws_instance" "bastion" {
  ami             = data.aws_ami.ubuntu20.id
  instance_type   = "t2.micro"
  key_name        = var.key_pair_key_name
  subnet_id       = element(module.vpc.public_subnets, 1)
  security_groups = [aws_security_group.allow-ssh-public-inbound.id]

  tags = {
    owner = var.owner
    TTL = var.ttl
  }

  connection {
    host          = aws_instance.bastion.public_dns
    user          = "ubuntu"
    private_key   = local.key_pair_private_key
  }

  provisioner "file" {
    source      = "${path.root}/tphan-hashicorp-aws.pem"
    destination = "/home/ubuntu/tphan-hashicorp-aws.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/tphan-hashicorp-aws.pem"
    ]
  }
}