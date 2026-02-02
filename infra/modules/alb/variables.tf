variable "name" {}
variable "subnets" { type = list(string) }
variable "security_groups" { type = list(string) }
variable "vpc_id" {}

variable "tags" { type = map(string) }
variable "certificate_arn" {
  type = string
}




variable "target_port" {
  type = string
}

