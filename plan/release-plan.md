# Release Plan

## Release Cadence

**Continuous deployment** — every push to `main` triggers an automatic deploy.

- **Content changes** (`apps/web-sirgrimorum/**`): Astro build → S3 sync → CloudFront invalidation via `deploy.yml`
- **Infra changes** (`infra/terraform/**`): Validated in CI via `terraform.yml`, applied manually
- **CDK changes** (`infra/cdk/**`): Deployed manually via `npx cdk deploy`

No versioned releases or tags — single static site with continuous delivery.

## Readiness Checklist

- [ ] CI passes (Astro build + type-check)
- [ ] Plan files updated if scope changed
- [ ] PR reviewed (if not pushing directly to `main`)

## Rollout

1. **PR merge to `main`** — triggers `deploy.yml` automatically
2. **Astro build** — generates static output in `dist/`
3. **S3 sync** — uploads built assets to `sirgrimorum-prod-marketing` bucket
4. **CloudFront invalidation** — `/*` path invalidation ensures fresh content
5. **Verify** — `curl -I https://sirgrimorum.com` returns 200 OK

## Rollback

If a bad deploy goes out:
1. Revert the commit on `main`
2. Push triggers a new deploy with the previous good state
3. CloudFront invalidation propagates within ~60 seconds
