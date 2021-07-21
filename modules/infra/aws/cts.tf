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

resource "local_file" "cts-client-config" {
  content = templatefile("${path.root}/examples/templates/client-config.json", {
    deployment_name       = "${var.deployment_name}-aws"
    consul_server_fqdn    = var.consul_server_fqdn
    consul_serf_lan_port  = var.consul_serf_lan_port
    node_name             = aws_instance.cts-node.private_dns
    })
  filename = "${path.module}/cts-client-config.json"
  
  depends_on = [
    aws_instance.cts-node
  ]
}

resource "null_resource" "cts-node" {
  connection {
    host          = aws_instance.cts-node.private_dns
    user          = "ubuntu"
    private_key   = local.key_pair_private_key
    bastion_host  = aws_instance.bastion-node.public_dns
  }

  provisioner "file" {
    source      = "${path.module}/cts-client-config.json"
    destination = "/tmp/client-config.json"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/client-config.json /opt/consul/config/default.json",
      "sudo /opt/consul/bin/run-consul --client --skip-consul-config"
    ]
  }

  depends_on = [
    local_file.cts-client-config
  ]
}