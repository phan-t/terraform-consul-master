locals {
  key_pair_private_key = file("${path.root}/tphan-hashicorp-aws.pem")
}

resource "aws_instance" "postgres" {

  ami             = "ami-0f60f69b4bda184b1"
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
    node_name             = aws_instance.postgres.private_dns
    })
  filename = "${path.module}/client-config.json.tmp"
  
  depends_on = [
    aws_instance.postgres
  ]
}

resource "null_resource" "consul-client-config" {
  connection {
    host          = aws_instance.postgres.private_dns
    user          = "ubuntu"
    agent         = false
    private_key   = local.key_pair_private_key
    bastion_host  = var.bastion_public_fqdn
  }

  provisioner "file" {
    source      = "${path.module}/client-config.json.tmp"
    destination = "/tmp/client-config.json"
  }

  provisioner "file" {
    source      = "${path.root}/consul-ent-license.hclic"
    destination = "/tmp/consul-ent-license.hclic"
  }

  provisioner "file" {
    source      = "${path.root}/examples/templates/consul-service-postgres.json"
    destination = "/tmp/consul-service-postgres.json"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/client-config.json /opt/consul/config/default.json",
      "sudo cp /tmp/consul-ent-license.hclic /opt/consul/bin/consul-ent-license.hclic",
      "sudo cp /tmp/consul-service-postgres.json /opt/consul/config/consul-service-postgres.json",
      "sudo /opt/consul/bin/run-consul --client --skip-consul-config",
      "sudo systemctl start consul-envoy"
    ]
  }

  depends_on = [
    local_file.consul-client-config
  ]
}