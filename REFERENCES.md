# AWS Landing Zone Reference Implementations

This document catalogs the key AWS reference implementations used as inspiration and best practices for this Landing Zone template.

## Primary References

### 1. AWS AFT Blueprints (RECOMMENDED)
**Repository**: https://github.com/awslabs/aft-blueprints

| Attribute | Value |
|-----------|-------|
| **Organization** | awslabs (AWS Labs - official AWS) |
| **Stars** | 41+ |
| **Last Updated** | Active (2024-2026) |
| **Focus** | AFT customization patterns |

**Why this is important:**
- Official AWS Labs project maintained by AWS Professional Services and Solution Architects
- Provides pre-defined architectural patterns for AFT (Account Factory for Terraform)
- Covers: Network/DNS, Centralized Backup, Identity Management, Security
- Uses dynamic Terraform providers and parametrized Landing Zone approach
- Minimizes deployment complexity with cross-account automation

**Patterns Available:**
- `single-region-basic` - Basic single region deployment
- `multi-region-basic` - Basic multi-region deployment  
- `multi-region-advanced` - Advanced multi-region with full features

**Modules Provided:**
- `backup` - Centralized backup configuration
- `compute` - Compute resources
- `custom_fields` - AFT custom fields handling
- `dns` - DNS and Route53 configuration
- `iam` - IAM roles and policies
- `network` - VPC and networking
- `security` - Security baseline
- `storage` - Storage configurations

---

### 2. AWS Network Hub for Terraform
**Repository**: https://github.com/aws-samples/aws-network-hub-for-terraform

| Attribute | Value |
|-----------|-------|
| **Organization** | aws-samples |
| **Stars** | 102+ |
| **Last Updated** | Active |
| **Focus** | Centralized networking hub |

**Why this is important:**
- Demonstrates scalable, segregated, secured AWS network for multi-account organizations
- Uses Transit Gateway to separate production, non-production, and shared services traffic
- Includes centralized ingress/egress behind Network Firewall
- Centralizes private VPC endpoints across all VPCs
- Manages IP address allocation using Amazon VPC IPAM
- Clean, composable modules that are easily extended

**Key Components:**
- Transit Gateway with route table segregation (prod, dev, shared)
- Network Firewall for centralized inspection
- VPC Endpoints (centralized)
- Route53 Resolver for DNS
- VPC IPAM for IP management
- Spoke VPC example included

**Architecture Highlights:**
```
Network Hub Account
├── Transit Gateway
│   ├── Route Tables: prod, dev, shared
│   └── RAM shared to organization
├── Inspection VPC (Network Firewall)
├── VPC Endpoints VPC (centralized endpoints)
├── DNS VPC (Route53 Resolver)
└── IPAM (organization-wide IP management)
```

---

### 3. AWS Security Reference Architecture (SRA)
**Repository**: https://github.com/aws-samples/aws-security-reference-architecture-examples

| Attribute | Value |
|-----------|-------|
| **Organization** | aws-samples |
| **Stars** | 1112+ |
| **Last Updated** | Active |
| **Focus** | Security services configuration |

**Why this is important:**
- Most starred AWS security implementation
- Implements patterns from the official AWS Security Reference Architecture guide
- Includes both CloudFormation and Terraform examples
- Covers Control Tower integration
- Comprehensive security service configurations

**Solutions Covered:**
- GuardDuty organization setup
- Security Hub configuration
- AWS Config rules
- CloudTrail organization trail
- IAM Access Analyzer
- Macie
- Detective
- Firewall Manager

---

### 4. AWS Startup Landing Zone Terraform Example
**Repository**: https://github.com/aws-samples/aws-startup-landing-zone-terraform-example

| Attribute | Value |
|-----------|-------|
| **Organization** | aws-samples |
| **Stars** | 25+ |
| **Focus** | Startup-focused landing zone |

**Structure:**
```
├── environments/     # Environment configurations
├── modules/          # Terraform modules
└── docs/            # Documentation
```

---

## Supporting References

### AFT Bootstrap Pipeline
**Repository**: https://github.com/aws-samples/aft-bootstrap-pipeline
- Infrastructure as code to bootstrap AFT following best practices
- 7 stars, actively maintained

### Terraform AWS Organization Policies
**Repository**: https://github.com/aws-samples/terraform-aws-organization-policies
- Deploy SCPs, RCPs, and other AWS organization policies
- 104 stars

### AWS Control Tower Controls with Terraform
**Repository**: https://github.com/aws-samples/aws-control-tower-controls-terraform
- Implement preventive, detective, and proactive security controls
- 105 stars

### GuardDuty for Organizations with Terraform
**Repository**: https://github.com/aws-samples/amazon-guardduty-for-aws-organizations-with-terraform
- Enable GuardDuty across AWS Organizations
- 67 stars

---

## Community References

### MCAF Landing Zone (Schuberg Philis)
**Repository**: https://github.com/schubergphilis/terraform-aws-mcaf-landing-zone
- Production-ready landing zone module
- 39 stars, actively maintained since 2020
- Used by enterprise customers

### MitocGroup Landing Zone
**Repository**: https://github.com/MitocGroup/terraform-aws-landing-zone
- 176 stars (most starred community implementation)
- Comprehensive module approach

---

## How We Use These References

### AFT Implementation
- Primary reference: `awslabs/aft-blueprints`
- Pattern: `single-region-basic` as starting point
- Modules: Adapt `iam`, `security`, `network` modules

### Network Architecture
- Primary reference: `aws-samples/aws-network-hub-for-terraform`
- Adopt Transit Gateway route table strategy (prod/dev/shared)
- Use IPAM for IP management
- Centralize VPC endpoints

### Security Baseline
- Primary reference: `aws-samples/aws-security-reference-architecture-examples`
- Implement GuardDuty, Security Hub, Config organization-wide
- Follow SRA patterns for delegated admin

### Organization Policies
- Reference: `aws-samples/terraform-aws-organization-policies`
- Implement SCPs following AWS best practices

---

## Key Learnings from References

### From AFT Blueprints:
1. Use dynamic Terraform providers for cross-account operations
2. Parametrize the Landing Zone to minimize configuration
3. Leverage integrations between architectural components
4. Use SSM Parameter Store for cross-account/region data sharing

### From Network Hub:
1. Separate TGW route tables by environment (prod, dev, shared)
2. Centralize VPC endpoints in a dedicated VPC
3. Use Network Firewall for centralized inspection
4. Implement IPAM for IP address management at organization level
5. Use RAM for resource sharing across accounts

### From SRA:
1. Delegate admin to Security account for security services
2. Aggregate Config to central account
3. Centralize CloudTrail logs in Log Archive account
4. Enable GuardDuty S3 and EKS protection

---

## Links

- [AWS AFT Documentation](https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html)
- [AWS Security Reference Architecture](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/)
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
