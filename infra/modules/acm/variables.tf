variable "domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
}

variable "zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
}

variable "tags" {
  description = "Optional tags for resources"
  type        = map(string)
  default     = {}
}
