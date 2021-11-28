resource "consul_config_entry" "gcp-terminating_gateway" {
  name = "gcp-terminating-gateway"
  kind = "terminating-gateway"

  config_json = jsonencode({
    Services = [{ Name = "payments-queue" }]
  })
}