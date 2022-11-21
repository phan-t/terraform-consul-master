resource "consul_node" "memorystore" {
  provider = consul.gcp

  address   = module.memorystore.host
  name      = "payments-queue"
  partition = "payments"

  meta = {
    "external-node"  = "true"
    "external-probe" = "false"
  }
}

// consul external service registration

resource "consul_service" "memorystore" {
  provider = consul.gcp

  name      = "payments-queue"
  node      = consul_node.memorystore.name
  port      = module.memorystore.port
  partition = "payments"

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