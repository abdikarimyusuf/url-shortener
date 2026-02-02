resource "aws_route53_record" "this" {
  zone_id         = var.zone_id
  name            = var.domain_name
  type            = "A"
  allow_overwrite = true
  alias {
    name                   = var.alb_dns
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}