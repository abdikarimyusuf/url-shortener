output "table_name" {
  value = aws_dynamodb_table.ddb.name
}

output "table_arn" {
  value = aws_dynamodb_table.ddb.arn
}

output "hash_key" {
  value = var.hash_key
}