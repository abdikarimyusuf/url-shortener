variable "cluster_name" {
  default = "threatsc-pro"
}
variable "db_secret_arn" {
  description = "Secrets Manager ARN for DB credentials"
  type        = string
}


