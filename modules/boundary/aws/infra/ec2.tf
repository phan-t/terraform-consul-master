locals {
  key_pair_private_key = file("${path.root}/tphan-hashicorp-aws.pem")
}

resource "aws_instance" "controller" {
  ami                   = "ami-001311716238cd89b"
  instance_type         = "t2.micro"
  iam_instance_profile  = aws_iam_instance_profile.boundary.name
  key_name              = var.key_pair_key_name
  subnet_id             = element(var.public_subnet_ids, 1)
  security_groups       = [var.security_group_allow_ssh_inbound_id, aws_security_group.allow-boundary-controller-public-inbound.id]

  tags = {
    owner = var.owner
    TTL = var.ttl
  }

  connection {
    host          = aws_instance.controller.public_dns
    user          = "ubuntu"
    private_key   = local.key_pair_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/pki/tls/boundary",
      "echo '${tls_private_key.boundary.private_key_pem}' | sudo tee ${var.tls_key_path}",
      "echo '${tls_self_signed_cert.boundary.cert_pem}' | sudo tee ${var.tls_cert_path}"
    ]
  }
}
resource "local_file" "boundary-controller-config" {
  content = templatefile("${path.root}/examples/templates/boundary-controller-config.hcl", {
    deployment_name        = var.deployment_name
    db_endpoint            = aws_db_instance.boundary.endpoint
    private_ip             = aws_instance.controller.private_ip
    tls_disabled           = var.tls_disabled
    tls_key_path           = var.tls_key_path
    tls_cert_path          = var.tls_cert_path
    kms_type               = var.kms_type
    kms_worker_auth_key_id = aws_kms_key.worker_auth.id
    kms_recovery_key_id    = aws_kms_key.recovery.id
    kms_root_key_id        = aws_kms_key.root.id
    })
  filename = "${path.module}/boundary-controller-config.hcl"
  
  depends_on = [
    aws_instance.controller
  ]
}

resource "null_resource" "controller" {
  connection {
    host          = aws_instance.controller.public_dns
    user          = "ubuntu"
    private_key   = local.key_pair_private_key
  }

  provisioner "file" {
    source      = "${path.module}/boundary-controller-config.hcl"
    destination = "/tmp/boundary-controller.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/boundary-controller.hcl /opt/boundary/config/boundary-controller.hcl",
      "sudo /opt/boundary/bin/run-boundary controller"
    ]
  }

  depends_on = [
    local_file.boundary-controller-config
  ]
}

resource "aws_instance" "worker" {
  ami                   = "ami-001311716238cd89b"
  instance_type         = "t2.micro"
  iam_instance_profile  = aws_iam_instance_profile.boundary.name
  key_name              = var.key_pair_key_name
  subnet_id             = element(var.public_subnet_ids, 1)
  security_groups       = [var.security_group_allow_ssh_inbound_id, aws_security_group.allow-boundary-worker-public-inbound.id]

  tags = {
    owner = var.owner
    TTL = var.ttl
  }

  connection {
    host          = aws_instance.worker.public_dns
    user          = "ubuntu"
    private_key   = local.key_pair_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/pki/tls/boundary",
      "echo '${tls_private_key.boundary.private_key_pem}' | sudo tee ${var.tls_key_path}",
      "echo '${tls_self_signed_cert.boundary.cert_pem}' | sudo tee ${var.tls_cert_path}"
    ]
  }
}
resource "local_file" "boundary-worker-config" {
  content = templatefile("${path.root}/examples/templates/boundary-worker-config.hcl", {
    controller_ips         = aws_instance.controller.*.private_ip
    deployment_name        = var.deployment_name
    public_ip              = aws_instance.worker.public_ip
    private_ip             = aws_instance.worker.private_ip
    tls_disabled           = var.tls_disabled
    tls_key_path           = var.tls_key_path
    tls_cert_path          = var.tls_cert_path
    kms_type               = var.kms_type
    kms_worker_auth_key_id = aws_kms_key.worker_auth.id
    })
  filename = "${path.module}/boundary-worker-config.hcl"
  
  depends_on = [
    aws_instance.worker
  ]
}

resource "null_resource" "worker" {
  connection {
    host          = aws_instance.worker.public_dns
    user          = "ubuntu"
    private_key   = local.key_pair_private_key
  }

  provisioner "file" {
    source      = "${path.module}/boundary-worker-config.hcl"
    destination = "/tmp/boundary-worker.hcl"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/boundary-worker.hcl /opt/boundary/config/boundary-worker.hcl",
      "sudo /opt/boundary/bin/run-boundary worker"
    ]
  }

  depends_on = [
    local_file.boundary-worker-config
  ]
}