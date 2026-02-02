
resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags
}


resource "aws_route53_record" "validation" {
  zone_id         = var.zone_id
  name            = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_type
  ttl             = 300
  records         = [tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_value]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [aws_route53_record.validation.fqdn]
}


