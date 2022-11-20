packer {
  required_version = ">= 1.5.4"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "consul_version" {
  type    = string
  default = "1.14.0+ent"
}

variable "consul_download_url" {
  type    = string
  default = "${env("CONSUL_DOWNLOAD_URL")}"
}

data "amazon-ami" "ubuntu20" {
  filters = {
    architecture                       = "x86_64"
    "block-device-mapping.volume-type" = "gp2"
    name                               = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    root-device-type                   = "ebs"
    virtualization-type                = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]
  region      = "${var.aws_region}"
}

source "amazon-ebs" "ubuntu20-ami" {
  ami_description             = "An Ubuntu 20.04 AMI that has Consul installed."
  ami_name                    = "postregs-consul-ubuntu-${formatdate("YYYYMMDDhhmm", timestamp())}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  region                      = "${var.aws_region}"
  source_ami                  = "${data.amazon-ami.ubuntu20.id}"
  ssh_username                = "ubuntu"
  tags = {
    application     = "postgres"
    consul_version  = "${var.consul_version}"
    owner           = "tphan@hashicorp.com"
    packer_source   = "https://github.com/phan-t/terraform-aws-consul/blob/master/examples/amis/consul/consul.pkr.hcl"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu20-ami"]

  provisioner "shell" {
    inline = ["mkdir -p /tmp/terraform-aws-consul/"]
  }

  provisioner "shell" {
    inline       = ["git clone --branch v0.10.1 https://github.com/hashicorp/terraform-aws-consul.git /tmp/terraform-aws-consul"]
    pause_before = "30s"
  }

  provisioner "shell" {
    inline       = ["if test -n \"${var.consul_download_url}\"; then", "/tmp/terraform-aws-consul/modules/install-consul/install-consul --download-url ${var.consul_download_url};", "else", "/tmp/terraform-aws-consul/modules/install-consul/install-consul --version ${var.consul_version};", "fi"]
    pause_before = "30s"
  }

  provisioner "shell" {
    inline       = ["/tmp/terraform-aws-consul/modules/setup-systemd-resolved/setup-systemd-resolved"]
    pause_before = "30s"
  }

  provisioner "shell" {
    script       = "scripts/postgres.sh"
  }
}
