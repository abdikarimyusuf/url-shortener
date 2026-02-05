variable "name" {
  description = "prefix for the table"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "hash_key" {
  description = "Partition key name"
  type        = string
  default     = "id"
}

variable "ttl_attribute" {
  description = "Attribute name for TTL (set null to disable TTL)"
  type        = string
  default     = null
}

variable "point_in_time_recovery" {
  description = "Enable PITR backups"
  type        = bool
  default     = false
}


