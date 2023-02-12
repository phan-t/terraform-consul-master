// create default partition cluster peering connection between aws and gcp

resource "consul_peering" "aws-gcp-default" {
  peer_name     = "aws-gcp-default"
  peering_token = var.default_peering_token
}