variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}
variable "ecs_port" {
  type    = number
  default = 8080
}

variable "project" {
  type        = string
  description = "Project name (used in naming and tags)"
  default     = "URL-SHORTERNER"
}

variable "environment" {
  type        = string
  description = "Environment name: dev, stage, prod"
}

variable "domain_name" {
  type        = string
  description = "Base domain, "
}

variable "sub_domain_name" {
  type        = string
  description = "App subdomain label, e.g. app"
}

# Networking
variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "db_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

# App images
variable "image" {
  type = string
}

# Ports
variable "container_port" {
  type    = number
  default = 8080
}


# ECS sizing
variable "ecs_cpu" {
  type    = string
  default = "512"
}

variable "ecs_memory" {
  type    = string
  default = "1024"
}

variable "ecs_desired_count" {
  type    = number
  default = 1
}

# Optional extra tagss
variable "extra_tags" {
  type    = map(string)
  default = {}
}


variable "env" {
  type = string
}

