variable "name_prefix" {
  description = "Prefix for database resources"
  type        = string
}

variable "engine" {
  description = "DB engine: postgres | mysql | mariadb"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "Instance size"
  type        = string
}

variable "allocated_storage" {
  description = "Initial storage size"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Max storage autoscaling limit"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database master user"
  type        = string
}



variable "subnet_ids" {
  description = "Private DB subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to RDS"
  type        = list(string)
}

variable "multi_az" {
  description = "Enable multi-AZ"
  type        = bool
  default     = false
}

variable "backup_retention" {
  description = "Days to keep backups"
  type        = number
  default     = 7
}

variable "storage_encrypted" {
  description = "Encrypt storage"
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "secret_name" {
  description = "Optional custom Secrets Manager name"
  type        = string
  default     = ""
}

variable "kms_key_id" {
  description = "Optional KMS key for secret encryption"
  type        = string
  default     = null
}

variable "env" {
  type = string
}

