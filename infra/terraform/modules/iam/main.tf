data "aws_caller_identity" "current" {}

# GitHub OIDC Provider
# AWS ignores the thumbprint for GitHub OIDC validation, but the field is required.
# Value sourced from: https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# GitHub Actions deploy role
resource "aws_iam_role" "github_actions" {
  name = "sirgrimorum-${var.environment}-github-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# S3 deploy policy
resource "aws_iam_role_policy" "s3_deploy" {
  name = "s3-marketing-deploy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.marketing_bucket_arn,
          "${var.marketing_bucket_arn}/*"
        ]
      }
    ]
  })
}

# CDK deploy policy — allows assuming CDK bootstrap roles for cdk deploy from CI
resource "aws_iam_role_policy" "cdk_deploy" {
  name = "cdk-deploy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/cdk-hnb659fds-*-${data.aws_caller_identity.current.account_id}-us-east-1"
      }
    ]
  })
}

# CloudFront invalidation policy — created in phase 2 when distribution ARN is available
resource "aws_iam_role_policy" "cloudfront_invalidation" {
  count = var.cloudfront_distribution_arn != "" ? 1 : 0
  name  = "cloudfront-invalidation"
  role  = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "cloudfront:CreateInvalidation"
        Resource = var.cloudfront_distribution_arn
      }
    ]
  })
}
