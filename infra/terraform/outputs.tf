output "marketing_bucket_name" {
  value = module.storage.marketing_bucket_name
}

output "marketing_bucket_arn" {
  value = module.storage.marketing_bucket_arn
}

output "cloudfront_cert_arn" {
  value = module.dns.cloudfront_cert_arn
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}

output "cloudflare_zone_id" {
  value = module.dns.cloudflare_zone_id
}

output "budget_alerts_topic_arn" {
  value = module.budget.budget_alerts_topic_arn
}
