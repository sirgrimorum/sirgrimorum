# Manual Setup Guide

## Prerequisites

- Node.js 20+
- npm 10+
- AWS CLI (for infra and manual deploys)
- Terraform + CDK (for infra provisioning)

## Install

```bash
make install
# → cd apps/web-sirgrimorum && npm install
```

## Local build

```bash
make build
# → cd apps/web-sirgrimorum && npm run build
# Output: apps/web-sirgrimorum/dist/
```

## Local run

```bash
make dev
# → cd apps/web-sirgrimorum && npm run dev
# Starts Astro dev server at http://localhost:4321
```

## Type check

```bash
make typecheck
# → cd apps/web-sirgrimorum && npm run typecheck (astro check)
```

## CI command

```bash
make ci
# Runs: typecheck → (no tests yet)
```

## Manual deploy (without GitHub Actions)

Requires infra to be provisioned first (see `plan/sirgrimorum-landing.md` § Infrastructure).

```bash
make build
aws s3 sync apps/web-sirgrimorum/dist/ s3://<MARKETING_S3_BUCKET> \
  --delete \
  --cache-control "no-cache" \
  --include "*.html"
aws s3 sync apps/web-sirgrimorum/dist/ s3://<MARKETING_S3_BUCKET> \
  --delete \
  --cache-control "public, max-age=31536000, immutable" \
  --exclude "*.html"
aws cloudfront create-invalidation \
  --distribution-id <CF_DISTRIBUTION_ID> \
  --paths "/*"
```

## Troubleshooting

- **Astro check fails with type errors**: Run `npm install` inside `apps/web-sirgrimorum/` to ensure `astro/tsconfigs/strict` is available.
- **S3 sync: AccessDenied**: Verify the GitHub OIDC role trust policy matches the repo and branch (`refs/heads/main`).
- **CloudFront serving stale content**: Run the `create-invalidation` step manually with `--paths "/*"`.
