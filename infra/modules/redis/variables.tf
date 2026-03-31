variable "name" {
  type = string
}

variable "node_type" {
  type    = string
  default = "cache.t3.micro"
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}