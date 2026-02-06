output "web_acl_arn" {
  value       = aws_wafv2_web_acl.this.arn
  description = "WAF Web ACL ARN"
}

output "web_acl_name" {
  value       = aws_wafv2_web_acl.this.name
  description = "WAF Web ACL name"
}
