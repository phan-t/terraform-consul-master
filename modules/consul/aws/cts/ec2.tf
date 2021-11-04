locals {
  key_pair_private_key = file("${path.root}/tphan-hashicorp-aws.pem")
}

resource "aws_instance" "cts" {

  ami             = "ami-01a21c7cd84cb237d"
  instance_type   = "t3.small"
  key_name        = var.key_pair_key_name
  subnet_id       = element(var.private_subnet_ids, 1)
  security_groups = [var.security_group_allow_ssh_inbound_id, var.security_group_allow_any_private_inbound_id]

  tags = {
    owner = var.owner
    TTL = var.ttl
  }
  
}

resource "local_file" "consul-client-config" {
  content = templatefile("${path.root}/examples/templates/consul-client-config.json", {
    deployment_name       = "${var.deployment_name}-aws"
    server_private_fqdn   = var.server_private_fqdn
    serf_lan_port         = tostring(var.serf_lan_port)
    node_name             = aws_instance.cts.private_dns
    })
  filename = "${path.module}/client-config.json"
  
  depends_on = [
    aws_instance.cts
  ]
}

resource "null_resource" "consul-client-config" {
  connection {
    host          = aws_instance.cts.private_dns
    user          = "ubuntu"
    private_key   = local.key_pair_private_key
    bastion_host  = var.bastion_public_fqdn
  }

  provisioner "file" {
    source      = "${path.module}/client-config.json"
    destination = "/tmp/client-config.json"
  }

  provisioner "file" {
    source      = "${path.root}/consul-ent-license.hclic"
    destination = "/tmp/consul-ent-license.hclic"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/client-config.json /opt/consul/config/default.json",
      "sudo cp /tmp/consul-ent-license.hclic /opt/consul/bin/consul-ent-license.hclic",
      "sudo /opt/consul/bin/run-consul --client --skip-consul-config"
    ]
  }

  depends_on = [
    local_file.consul-client-config
  ]
}

resource "local_file" "consul-cts-config" {
  content = templatefile("${path.root}/examples/templates/consul-cts-config.hcl", {
    })
  filename = "${path.module}/cts-config.hcl"
  
  depends_on = [
    aws_instance.cts
  ]
}

resource "null_resource" "consul-cts-config" {
  connection {
    host          = aws_instance.cts.private_dns
    user          = "ubuntu"
    private_key   = local.key_pair_private_key
    bastion_host  = var.bastion_public_fqdn
  }

  provisioner "file" {
    source      = "${path.module}/cts-config.hcl"
    destination = "/tmp/cts-config.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/cts-config.hcl /opt/consul-terraform-sync/config/cts-config.hcl",
      "sudo /opt/consul-terraform-sync/bin/run-consul-cts"
    ]
  }

  depends_on = [
    null_resource.consul-client-config,
    local_file.consul-cts-config
  ]
}