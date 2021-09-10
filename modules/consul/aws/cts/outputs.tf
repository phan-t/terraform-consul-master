output "private_fqdn" {
  description = "Private fqdn"
  value       = aws_instance.cts.private_dns
}