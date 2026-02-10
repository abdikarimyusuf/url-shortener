variable "name_prefix" {
  type        = string
  description = "Name prefix for WAF resources"
}

variable "alb_arn" {
  type        = string
  description = "ARN of the ALB to attach the WAF to"
}

variable "rate_limit" {
  type        = number
  description = "Requests per 5 minutes per IP before blocking (set 0 to disable)"
  default     = 0
}

variable "tags" {
  type    = map(string)
  default = {}
}
