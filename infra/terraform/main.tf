provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "sirgrimorum"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "dns" {
  source = "./modules/dns"

  domain                         = var.domain
  cloudfront_distribution_domain = var.cloudfront_distribution_domain
}

module "storage" {
  source = "./modules/storage"

  environment                          = var.environment
  marketing_cloudfront_distribution_arn = var.marketing_cloudfront_distribution_arn
}

module "iam" {
  source = "./modules/iam"

  environment                = var.environment
  github_org                 = var.github_org
  github_repo                = var.github_repo
  marketing_bucket_arn       = module.storage.marketing_bucket_arn
  cloudfront_distribution_arn = var.marketing_cloudfront_distribution_arn
  terraform_state_bucket_arn = "arn:aws:s3:::sirgrimorum-terraform-state"
  terraform_lock_table_arn   = "arn:aws:dynamodb:us-east-1:369292121060:table/sirgrimorum-terraform-locks"
}

module "budget" {
  source = "./modules/budget"

  environment        = var.environment
  budget_limit       = var.budget_limit
  budget_alert_email = var.budget_alert_email
  create_budgets     = var.create_budgets
}
