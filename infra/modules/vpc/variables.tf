variable "name_prefix" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)

}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}


variable "tags" {
  description = "Optional tags for resources"
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  type = list(string)
}
variable "db_subnets" {
  type    = list(string)
  default = []
}


variable "enable_db_tier" {
  type    = bool
  default = true
}
