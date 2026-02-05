variable "vpc_id" { type = string }
variable "desired_count" { default = 1 }
variable "subnets" { type = list(string) }
variable "security_group" { type = list(string) }
variable "target_group_arn" {}
variable "container_port" {}
variable "family" {}
variable "cpu" {}
variable "memory" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}

variable "image" {}


variable "region" {}


variable "cluster_name" {
  type = string
}
variable "service_name" {
  type = string
}

variable "TABLE_NAME" {
  type = string
}


variable "container_log_group" { type = string }



