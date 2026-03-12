# Architecture Plan

## Current Architecture

New monorepo — nothing deployed yet. Target state described below.

**Boundaries:**
- `apps/web-sirgrimorum/` — static HTML/CSS, no framework, no build step
- `infra/terraform/` — S3 bucket, ACM certs, Cloudflare DNS, GitHub OIDC IAM role
- `infra/cdk/` — CloudFront distribution + S3 OAC
- `.github/workflows/` — GHA deploy pipeline (S3 sync + CF invalidation)

**AWS account:** Separate org member account (not the brain-mcp account).
**Reference implementation:** `../brain-mcp/infra/` — same Terraform + CDK pattern.

## Contract-First Boundaries

- **Terraform → CDK**: Terraform creates S3 bucket + ACM certs; CDK imports them via CDK context (bucket name/ARN, cert ARN).
- **CDK → Terraform (phase 2)**: After CDK deploy, CloudFront distribution domain + ARN are written back to `prod.tfvars` so Terraform can create the Cloudflare CNAMEs and OAC bucket policy.
- **CDK → GitHub Actions**: CloudFront distribution ID and S3 bucket name are stored as GitHub Actions variables (`CF_DISTRIBUTION_ID`, `MARKETING_S3_BUCKET`).

## Planned Changes

1. Create `infra/terraform/` with modules: `dns`, `storage`, `iam`, `budget`
2. Create `infra/cdk/` with single `CloudFrontStack` (distribution + OAC)
3. Create `apps/web-sirgrimorum/index.html` (steampunk pixel art static page)
4. Create `.github/workflows/deploy.yml` (S3 sync + CF invalidation, OIDC auth)

## E2E Track Outcomes

- Track A: `https://sirgrimorum.com` serves `index.html` over HTTPS via CloudFront
- Track B: GitHub Actions deploy runs on push to `main` with no manual steps

## Decision Log

- 2026-03-11 — Selected S3 + CloudFront (Option A) over GitHub Pages — already have AWS org account, keeps infra consistent with brain-mcp/vitalidad, no repo visibility constraint
- 2026-03-11 — No build step — pure static `index.html`, deploy is a direct S3 sync
- 2026-03-11 — Single `prod` environment only — no staging needed for a static landing page
- 2026-03-11 — No networking module — no VPC needed for CloudFront + S3
