output "db_endpoint" {
  value = aws_db_instance.db_ins.endpoint
}

output "db_name" {
  value = var.db_name
}

output "db_port" {
  value = aws_db_instance.db_ins.port
}

output "db_engine" {
  value = aws_db_instance.db_ins.engine
}

output "db_identifier" {
  value = aws_db_instance.db_ins.id
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret with DB credentials"
  value       = aws_secretsmanager_secret.db.arn
}

output "secret_name" {
  description = "Name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.db.name
}


