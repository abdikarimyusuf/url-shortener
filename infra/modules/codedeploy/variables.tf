variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "service_role_arn" {
  description = "IAM role ARN for CodeDeploy"
  type        = string
}

variable "deployment_config_name" {
  description = "Deployment strategy (AllAtOnce, Linear, Canary)"
  type        = string
}

variable "deployment_type" {
  description = "Deployment type (e.g. BLUE_GREEN)"
  type        = string
}

variable "deployment_option" {
  description = "Deployment option (e.g. WITH_TRAFFIC_CONTROL)"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "blue_target_group_name" {
  description = "Blue target group name"
  type        = string
}

variable "green_target_group_name" {
  description = "Green target group name"
  type        = string
}

variable "listener_arns" {
  description = " ALB listener ARNs"
  type        = list(string)
}