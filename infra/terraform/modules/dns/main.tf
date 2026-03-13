terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.0"
    }
  }
}

data "cloudflare_zone" "main" {
  filter = {
    name = var.domain
  }
}

# ACM certificate for CloudFront (must be us-east-1)
resource "aws_acm_certificate" "cloudfront" {
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# DNS validation records in Cloudflare
resource "cloudflare_dns_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
    if dvo.domain_name == var.domain
  }

  zone_id = data.cloudflare_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value
  ttl     = 300
}

resource "aws_acm_certificate_validation" "cloudfront" {
  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.acm_validation : record.name]
}

# Cloudflare CNAME records pointing to CloudFront (created in phase 2)
resource "cloudflare_dns_record" "root" {
  count = var.cloudfront_distribution_domain != "" ? 1 : 0

  zone_id = data.cloudflare_zone.main.zone_id
  name    = var.domain
  type    = "CNAME"
  content = var.cloudfront_distribution_domain
  proxied = false
  ttl     = 300
}

resource "cloudflare_dns_record" "www" {
  count = var.cloudfront_distribution_domain != "" ? 1 : 0

  zone_id = data.cloudflare_zone.main.zone_id
  name    = "www.${var.domain}"
  type    = "CNAME"
  content = var.cloudfront_distribution_domain
  proxied = false
  ttl     = 300
}
