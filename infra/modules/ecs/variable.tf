variable "vpc_id" { type = string }
variable "desired_count" { default = 1 }
variable "subnets" { type = list(string) }
variable "security_group" { type = list(string) }
variable "target_group_arn" {}
variable "frontend_port" {}
variable "backend_port" {}
variable "family" {}
variable "cpu" {}
variable "memory" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}

variable "backend_image" {}
variable "frontend_image" {}

variable "region" {}
variable "database_secret_arn" {
  description = "Secrets Manager ARN for DATABASE_URL"
  type        = string
}
variable "cluster_name" {
  type = string
}
variable "service_name" {
  type = string
}


variable "frontend_log_group" { type = string }
variable "backend_log_group" { type = string }


