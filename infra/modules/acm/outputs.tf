

output "certificate_arn" {
  description = "ARN of the validated ACM certificate"
  value       = aws_acm_certificate.this.arn
}

output "validation_record_fqdn" {
  description = "FQDN of the DNS validation record"
  value       = aws_route53_record.validation.fqdn
}
