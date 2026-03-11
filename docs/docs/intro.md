---
sidebar_position: 1
slug: /
description: Start here to understand the AWS Landing Zone Template, its core components, and the recommended deployment path.
---

# Introduction

The **AWS Landing Zone Template** is a Docusaurus-documented, Terraform-based foundation for building a multi-account AWS environment with clear governance, security, networking, and account-vending patterns.

## What This Template Includes

- **Organization foundations** with AWS Organizations, OUs, and SCPs
- **Security baseline** with GuardDuty, Security Hub, Config, and centralized logging
- **Network hub patterns** for shared connectivity and DNS
- **AFT integration** for automated account provisioning and customization
- **Operational documentation** for deployment, troubleshooting, and day-to-day workflows

## Before You Start

- AWS CLI v2 configured with access to the management account
- Terraform `>= 1.5.0`
- Node.js `>= 20` for the documentation site
- Beads CLI (`bd`) for project task tracking

## Recommended First Steps

1. Review the [Architecture Overview](./architecture/overview).
2. Read the [Control Tower Setup](./architecture/control-tower) guide.
3. Follow the [Deployment Runbook](./runbooks/deployment).
4. Use the [Account Vending Runbook](./runbooks/account-vending) when you are ready to provision workload accounts.

## Repository Structure

```text
aws-landing-zone-template/
├── terraform/
│   ├── organization/      # AWS Organizations, OUs, SCPs
│   ├── security/          # GuardDuty, Security Hub, Config
│   ├── log-archive/       # CloudTrail, Config, centralized logs
│   ├── network/           # Transit Gateway, VPCs, DNS
│   ├── shared-services/   # CI/CD, registries, shared tooling
│   ├── aft/               # Account Factory for Terraform integration
│   └── modules/           # Reusable Terraform modules
├── docs/                  # Docusaurus site and documentation content
├── infra/                 # SST deployment for the docs site
└── scripts/               # Helper scripts for local workflows
```

## Suggested Reading

- [Security Model](./architecture/security-model)
- [Network Design](./architecture/network-design)
- [IAM Strategy](./architecture/iam-strategy)
- [Modules](./modules/organization)
- [Runbooks](./runbooks/deployment)

## Support

- [GitHub Issues](https://github.com/your-org/aws-landing-zone-template/issues)
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
