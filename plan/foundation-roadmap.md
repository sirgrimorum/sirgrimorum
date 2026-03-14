# Foundation Roadmap

## Foundation Capability: S3 + CloudFront Hosting Pipeline ✅

**Status**: Deployed

### Capability Outcome

Fully automated static site hosting pipeline: Terraform provisions infra (S3, ACM, Cloudflare DNS, IAM OIDC, budget alerts), CDK deploys CloudFront distribution with OAC, GitHub Actions deploys content on push to `main`.

### Reuse and Simplicity

- Existing components reused: Same Terraform + CDK pattern as `brain-mcp` and `vitalidad`
- Complexity controls: No VPC, no DynamoDB, no ECR — minimal subset for static hosting only

### Contract Impact

- Contracts added:
  - **Terraform → CDK**: S3 bucket name/ARN + ACM cert ARN passed via CDK context
  - **CDK → Terraform**: CloudFront distribution domain + ARN written back to `prod.tfvars` (phase 2)
  - **CDK → GitHub Actions**: `CF_DISTRIBUTION_ID` and `MARKETING_S3_BUCKET` stored as GHA variables
- Backward compatibility: N/A (greenfield)

### E2E Enablement

- Unlocks: Landing page feature, any future static content at `sirgrimorum.com`

### Verification

- [x] Terraform apply succeeds (phase 1 + phase 2)
- [x] CDK deploy succeeds (CloudFront distribution E2GG0KR8IYR869)
- [x] GitHub Actions deploy workflow runs on push to `main`
- [x] `curl -I https://sirgrimorum.com` → 200 OK

---

## Foundation Capability: CI Pipeline ✅

**Status**: Deployed

### Capability Outcome

GitHub Actions CI runs on PRs: lints, type-checks, and builds the Astro site. Terraform validation runs on infra changes.

### Reuse and Simplicity

- Existing components reused: Standard GHA actions (`actions/checkout`, `actions/setup-node`, `aws-actions/configure-aws-credentials`)
- Complexity controls: Three focused workflows (`ci.yml`, `deploy.yml`, `terraform.yml`) instead of one monolithic pipeline

### Contract Impact

- Contracts added: OIDC trust policy scoped to `repo:sirgrimorum/sirgrimorum:ref:refs/heads/main`
- Backward compatibility: N/A (greenfield)

### E2E Enablement

- Unlocks: Safe continuous deployment for all future features

### Verification

- [x] CI workflow passes on PRs
- [x] Deploy workflow triggers on push to `main`
- [x] Terraform workflow validates infra changes
