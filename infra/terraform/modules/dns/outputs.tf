output "cloudfront_cert_arn" {
  value = aws_acm_certificate.cloudfront.arn
}

output "cloudflare_zone_id" {
  value = data.cloudflare_zone.main.zone_id
}
