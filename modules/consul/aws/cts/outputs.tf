output "cts_node_private_fqdn" {
  description = "Private fqdn of CTS node"
  value       = aws_instance.cts-node.private_dns
}