variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "private_route_table_ids" {
  type = list(string)
}

variable "endpoints_sg_id" {
  type = string
}

# Optional toggles (keep simple; default true)
variable "enable_secretsmanager" {
  type    = bool
  default = true
}


variable "tags" {
  type    = map(string)
  default = {}
}