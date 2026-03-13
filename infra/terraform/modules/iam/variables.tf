variable "environment" {
  type = string
}

variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "marketing_bucket_arn" {
  type = string
}

variable "cloudfront_distribution_arn" {
  type    = string
  default = ""
}
