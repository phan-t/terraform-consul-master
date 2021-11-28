resource "consul_node" "memorystore" {
  name    = "payments-queue"
  address = module.memorystore.host

  meta = {
    "external-node"  = "true"
    "external-probe" = "false"
  }
}

resource "consul_service" "memorystore" {
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

resource "consul_config_entry" "gcp-terminating_gateway" {
  name = "gcp-terminating-gateway"
  kind = "terminating-gateway"

  config_json = jsonencode({
    Services = [{ Name = "payments-queue" }]
  })
}