packer {
  required_version = ">= 1.5.4"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "consul_version" {
  type    = string
  default = "1.10.3+ent"
}

variable "consul_download_url" {
  type    = string
  default = "${env("CONSUL_DOWNLOAD_URL")}"
}

variable "envoy_version" {
  type    = string
  default = "1.18.3"
}

variable "application_name" {
  type    = string
  default = "postgres"
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
  ami_name                    = "product-api-db-consul-ubuntu-${formatdate("YYYYMMDDhhmm", timestamp())}"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  region                      = "${var.aws_region}"
  source_ami                  = "${data.amazon-ami.ubuntu20.id}"
  ssh_username                = "ubuntu"
  tags = {
    application     = "${var.application_name}"
    consul_version  = "${var.consul_version}"
    envoy_version   = "${var.envoy_version}"
    owner           = "tphan@hashicorp.com"
    packer_source   = "https://github.com/phan-t/terraform-aws-consul/blob/master/examples/amis/hashicups/product-api-db/product-api-db-consul.pkr.hcl"
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu20-ami"]

  provisioner "shell" {
    inline = ["mkdir -p /tmp/terraform-aws-consul/", "mkdir -p /tmp/terraform-consul-master/"]
  }

  provisioner "shell" {
    inline       = ["git clone --branch v0.10.1 https://github.com/hashicorp/terraform-aws-consul.git /tmp/terraform-aws-consul", "git clone https://github.com/phan-t/terraform-consul-master.git /tmp/terraform-consul-master"]
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
    inline       = ["sudo curl -L https://func-e.io/install.sh | bash -s -- -b /tmp", "/tmp/func-e use ${var.envoy_version}", "sudo cp ~/.func-e/versions/${var.envoy_version}/bin/envoy /usr/local/bin/"]
    pause_before = "30s"
  } 

  provisioner "shell" {
    inline       = ["/tmp/terraform-consul-master/examples/scripts/run-consul-envoy ${var.application_name}"]
    pause_before = "30s"
  }

  provisioner "shell" {
    script       = "scripts/product-api-db.sh"
    pause_before = "30s"
  }
}