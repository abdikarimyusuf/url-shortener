output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "db_subnet_ids" {
  value = var.enable_db_tier ? aws_subnet.db[*].id : []
}

output "nat_gateway_id" {
  value = var.enable_nat_gateway ? aws_nat_gateway.ngw[0].id : null
}