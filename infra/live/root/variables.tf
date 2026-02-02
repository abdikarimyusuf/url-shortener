variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}

variable "project" {
  type        = string
  description = "Project name (used in naming and tags)"
  default     = "memos"
}

variable "environment" {
  type        = string
  description = "Environment name: dev, stage, prod"
}

variable "domain_name" {
  type        = string
  description = "Base domain, e.g. abdikarim.co.uk"
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
  default = true
}

# App images
variable "frontend_image" {
  type = string
}

variable "backend_image" {
  type = string
}

# Ports
variable "frontend_port" {
  type    = number
  default = 80
}

variable "backend_port" {
  type    = number
  default = 8081
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

# DB
variable "db_name" {
  type    = string
  default = "memos"
}

variable "db_username" {
  type    = string
  default = "memos"
}

variable "db_engine_version" {
  type    = string
  default = "15"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_multi_az" {
  type    = bool
  default = false
}

variable "db_backup_retention" {
  type    = number
  default = 1
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}

# Optional extra tagss
variable "extra_tags" {
  type    = map(string)
  default = {}
}


variable "env" {
  type = string
}

