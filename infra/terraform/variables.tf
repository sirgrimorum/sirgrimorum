variable "environment" {
  type = string
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "Environment must be staging or prod."
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "domain" {
  type    = string
  default = "sirgrimorum.com"
}

variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudfront_distribution_domain" {
  type        = string
  default     = ""
  description = "CloudFront distribution domain name. Populated after CDK deploy."
}

variable "marketing_cloudfront_distribution_arn" {
  type        = string
  default     = ""
  description = "CloudFront distribution ARN. Populated after CDK deploy."
}

variable "budget_limit" {
  type    = number
  default = 1
}

variable "budget_alert_email" {
  type    = string
  default = ""
}

variable "create_budgets" {
  type    = bool
  default = false
}
