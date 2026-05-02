output "alb_dns" {
  value = aws_lb.lb.dns_name
}

output "target_group_arn_blue" {
  value = aws_lb_target_group.blue.arn
}
output "target_group_arn_green" {
  value = aws_lb_target_group.green.arn
}

output "alb_zone_id" {
  value = aws_lb.lb.zone_id # needed for Route53
}

output "alb_https_arn" {

  value = aws_lb_listener.https.arn

}


output "alb_arn" {
  value = aws_lb.lb.arn
}
