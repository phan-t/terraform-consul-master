output "controller_public_fqdn" {
  description = "Public fqdn of boundary controller"
  value       = aws_instance.controller.public_dns
}

output "kms_recovery_key_id" {
  description = "Boundary KMS recovery key id"
  value = aws_kms_key.recovery.id
}