# resource "consul_acl_policy" "prometheus" {
#     name        = "prometheus-policy"
#     rules       = <<-RULE
#     agent_prefix "" {
#       policy = "read"
#     }
#     RULE
# }

# resource "consul_acl_token" "prometheus" {
#     description = "prometheus"
#     policies    = [consul_acl_policy.prometheus.name]
#     local       = true
# }

# data "consul_acl_token_secret_id" "prometheus" {
#     accessor_id = consul_acl_token.prometheus.id
# }