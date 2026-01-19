# AWS Landing Zone Template

A production-ready Terraform template for deploying a multi-account AWS Organization with security best practices.

## Features

- **Multi-Account Architecture**: Management, Security, Log Archive, Network Hub, Shared Services
- **Security Baseline**: GuardDuty, Security Hub, AWS Config, Access Analyzer
- **Network Hub**: Transit Gateway with hub-and-spoke topology
- **Account Factory (AFT)**: Automated account provisioning via Terraform
- **Documentation**: Docusaurus site deployable via SST to CloudFront
- **AI-Assisted Development**: Configured for OpenCode with Ralph Wiggum + Beads

## Quick Start

```bash
# Clone the repository
git clone https://github.com/clopca/aws-landing-zone-template.git
cd aws-landing-zone-template

# Run setup (installs Beads, dependencies)
./scripts/setup.sh

# View documentation locally
cd docs && pnpm install && pnpm start

# See available tasks
bd ready
```

## Repository Structure

```
aws-landing-zone-template/
├── terraform/
│   ├── organization/      # AWS Organizations, OUs, SCPs
│   ├── security/          # GuardDuty, Security Hub, Config
│   ├── log-archive/       # CloudTrail, Config, VPC Flow Logs
│   ├── network/           # Transit Gateway, VPCs, DNS
│   ├── shared-services/   # CI/CD, ECR
│   ├── aft/               # Account Factory for Terraform
│   │   ├── aft-setup/
│   │   ├── account-requests/
│   │   ├── aft-global-customizations/
│   │   ├── aft-account-customizations/
│   │   └── aft-account-provisioning/
│   └── modules/           # Reusable modules
│       ├── vpc/
│       ├── security-baseline/
│       └── transit-gateway/
├── docs/                  # Docusaurus documentation
├── infra/                 # SST for docs deployment
├── scripts/               # Helper scripts
├── .github/workflows/     # CI/CD (disabled by default)
└── .opencode/             # OpenCode configuration
```

## Deployment Order

1. **Organization** (Management Account)
2. **Log Archive** (Log Archive Account)
3. **Security** (Security Account)
4. **Network** (Network Hub Account)
5. **Shared Services** (Shared Services Account)
6. **AFT** (AFT Account)

See [Deployment Runbook](docs/docs/runbooks/deployment.md) for detailed instructions.

## Documentation

The documentation site can be run locally or deployed to AWS:

```bash
# Local development
cd docs && npm run start

# Deploy to AWS (via SST)
./scripts/docs-deploy.sh dev
```

## Configuration

Each Terraform directory has a `terraform.tfvars.example` file. Copy and customize:

```bash
cd terraform/organization
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

## Reference Implementations

This template is inspired by official AWS implementations:

- [awslabs/aft-blueprints](https://github.com/awslabs/aft-blueprints) - AFT patterns
- [aws-samples/aws-network-hub-for-terraform](https://github.com/aws-samples/aws-network-hub-for-terraform) - Network architecture
- [aws-samples/aws-security-reference-architecture-examples](https://github.com/aws-samples/aws-security-reference-architecture-examples) - Security baseline

See [REFERENCES.md](REFERENCES.md) for the complete list.

## Development with AI

This repository is configured for AI-assisted development using OpenCode:

- **Oh-My-OpenCode**: Enhanced agent capabilities
- **Ralph Wiggum**: Autonomous development loop
- **Beads**: Git-backed issue tracking

```bash
# View current tasks
bd ready

# Run autonomous loop
./scripts/ralph-loop.sh
```

## CI/CD

GitHub Actions workflows are included but disabled by default:

- `terraform-validate.yml.disabled` - Validates Terraform on PR
- `docs-deploy.yml.disabled` - Deploys docs to AWS

To enable, remove the `.disabled` suffix.

## Contributing

1. Create a task: `bd create --title="Your task" --type=task`
2. Make changes
3. Validate: `./scripts/tf-validate.sh`
4. Submit PR

## License

MIT
