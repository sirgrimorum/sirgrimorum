resource "aws_s3_bucket" "marketing" {
  bucket = "sirgrimorum-${var.environment}-marketing"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "marketing" {
  bucket = aws_s3_bucket.marketing.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "marketing" {
  bucket = aws_s3_bucket.marketing.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# OAC bucket policy — applied in phase 2 when CloudFront ARN is available
resource "aws_s3_bucket_policy" "marketing_oac" {
  count  = var.marketing_cloudfront_distribution_arn != "" ? 1 : 0
  bucket = aws_s3_bucket.marketing.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontOAC"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.marketing.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.marketing_cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}
