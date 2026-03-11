# Service Setup

## Principle

IaC-first: provision everything possible via code.

## Ownership Split

- Terraform owns foundational infrastructure:
  - networking
  - DNS/hosted zone + certificates
  - IAM deploy identities
  - baseline observability/log groups
- CDK owns application infrastructure:
  - APIs
  - compute/runtime stacks
  - databases and storage
  - event pipelines

## Manual Exceptions

- Account/bootstrap setup
- Domain registrar setup
- Third-party SaaS dashboard setup (auth, analytics, billing)

## Configuration Hygiene

- Minimize `.env` variables; keep configuration centralized and typed.
- Prefer managed secret stores for sensitive runtime config.
