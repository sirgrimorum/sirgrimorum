aws_profile = "sirg-main"
environment = "prod"
region      = "us-east-1"
domain      = "sirgrimorum.com"
github_org  = "sirgrimorum"
github_repo = "sirgrimorum"

# Populated after CDK deploy:
cloudfront_distribution_domain        = "d1m1oy42yu5b4n.cloudfront.net"
marketing_cloudfront_distribution_arn = "arn:aws:cloudfront::369292121060:distribution/E2GG0KR8IYR869"

budget_limit       = 1
budget_alert_email = "sirgrimorum+sirgrimorum@gmail.com"
create_budgets     = false # linked account — enable after payer activates
