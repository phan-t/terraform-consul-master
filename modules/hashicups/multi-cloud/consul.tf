// consul admin partitions

resource "consul_admin_partition" "frontend" {
  provider = consul.aws

  name        = "frontend"
  description = "Partition for frontend team"
}

resource "consul_admin_partition" "payments" {
  provider = consul.gcp

  name        = "payments"
  description = "Partition for payments team"
}

resource "consul_node" "memorystore" {
  provider = consul.gcp

  name    = "payments-queue"
  address = module.memorystore.host

  meta = {
    "external-node"  = "true"
    "external-probe" = "false"
  }
}

// consul external service registration

resource "consul_service" "memorystore" {
  provider = consul.gcp

  name = "payments-queue"
  node = consul_node.memorystore.name
  port = module.memorystore.port

  check {
    check_id = "service:redis"
    name     = "Redis health check"
    status   = "passing"
    tcp      = "${module.memorystore.host}:${module.memorystore.port}"
    interval = "30s"
    timeout  = "3s"
  }
}

// consul terminating gateway registration

resource "consul_config_entry" "gcp-terminating_gateway" {
  provider = consul.gcp

  name = "gcp-terminating-gateway"
  kind = "terminating-gateway"

  config_json = jsonencode({
    Services = [{ Name = "payments-queue" }]
  })
}