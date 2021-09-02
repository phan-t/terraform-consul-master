packer {
  required_version = ">= 1.5.4"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "boundary_version" {
  type    = string
  default = "0.5.1"
}

variable "boundary_download_url" {
  type    = string
  default = "${env("BOUNDARY_DOWNLOAD_URL")}"
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
  ami_description             = "An Ubuntu 20.04 AMI that has Boundary installed."
  ami_name                    = "boundary-ubuntu-${formatdate("YYYYMMDDhhmm", timestamp())}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  region                      = "${var.aws_region}"
  source_ami                  = "${data.amazon-ami.ubuntu20.id}"
  ssh_username                = "ubuntu"
  tags = {
    application     = "boundary"
    consul_version  = "${var.boundary_version}"
    owner           = "tphan@hashicorp.com"
    packer_source   = "https://github.com/phan-t/terraform-aws-consul/blob/master/examples/amis/boundary/boundary.pkr.hcl"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu20-ami"]

  provisioner "shell" {
    inline = ["mkdir -p /tmp/terraform-aws-consul/", "sudo mkdir -p /etc/pki/tls/boundary/"]
  }

  provisioner "shell" {
    inline       = ["git clone https://github.com/phan-t/terraform-consul-master.git /tmp/terraform-consul-master"]
    pause_before = "30s"
  }

  provisioner "shell" {
    inline       = ["if test -n \"${var.boundary_download_url}\"; then", "/tmp/terraform-consul-master/examples/scripts/install-boundary --download-url ${var.boundary_download_url};", "else", "/tmp/terraform-consul-master/examples/scripts/install-boundary --version ${var.boundary_version};", "fi"]
    pause_before = "30s"
  }
}
