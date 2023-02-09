// retrieve hcp consul data

data "hcp_consul_cluster" "consul" {
  cluster_id = "${var.deployment_name}-hcp"
}

resource "hcp_consul_cluster_root_token" "token" {
  cluster_id = data.hcp_consul_cluster.consul.id
}

data "hcp_consul_agent_kubernetes_secret" "consul" {
  cluster_id = data.hcp_consul_cluster.consul.cluster_id
}

// create admin partition on hcp consul

resource "consul_admin_partition" "hcp-hashicups" {
  provider = consul.hcp

  name        = "hashicups"
  description = "Partition for hashicups team"
}

# // set cluster peering through mesh gateways

# resource "consul_config_entry" "eks-mesh" {
#   provider = consul.hcp

#   name      = "mesh"
#   kind      = "mesh"
#   partition = "default"
#   namespace = "default"

#   config_json = jsonencode({
#       Peering = {
#           PeerThroughMeshGateways = true
#       }
#   })
# }

// create cluster peering token for aws-gcp

# resource "consul_peering_token" "aws-gcp" {
#   provider = consul.hcp

#   peer_name = "aws-gcp"
#   partition = "hashicups"
# }