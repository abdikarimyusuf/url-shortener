output "dynamodb_vpce_id" {
  value = aws_vpc_endpoint.dynamodb.id
}

output "s3_vpce_id" {
  value = aws_vpc_endpoint.s3.id
}

output "interface_vpce_ids" {
  value = { for k, v in aws_vpc_endpoint.interface : k => v.id }
}