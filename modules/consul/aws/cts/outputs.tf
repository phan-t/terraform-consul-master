output "cts_private_fqdn" {
  description = "Private fqdn of CTS"
  value       = aws_instance.cts.private_dns
}