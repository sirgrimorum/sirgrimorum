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

variable "terraform_state_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket used for Terraform remote state"
}

variable "terraform_lock_table_arn" {
  type        = string
  description = "ARN of the DynamoDB table used for Terraform state locking"
}
