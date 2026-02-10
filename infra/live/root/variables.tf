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
  default     = "dev"
}

variable "domain_name" {
  type        = string
  description = "Base domain, "
  default     = "abdikarim.co.uk"
}

variable "sub_domain_name" {
  type        = string
  description = "App subdomain label, e.g. app"
}

# Networking
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

# App images
variable "image" {
  type    = string
  default = "561041808710.dkr.ecr.eu-west-2.amazonaws.com/url-shortener:latest2"
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
  default = 2
}

# Optional extra tagss
variable "extra_tags" {
  type    = map(string)
  default = {}
}


variable "env" {
  type = string
}

