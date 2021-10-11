output "private_fqdn" {
  description = "Private fqdn"
  value       = aws_instance.web.private_dns
}