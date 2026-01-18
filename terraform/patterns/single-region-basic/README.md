# Single Region Basic Pattern

A minimal single-region deployment pattern for getting started with AWS Landing Zone.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     AWS Organization                         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ Management  │  │  Security   │  │ Log Archive │         │
│  │   Account   │  │   Account   │  │   Account   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Workload Accounts (us-east-1)           │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐             │   │
│  │  │  Prod   │  │   Dev   │  │  Test   │             │   │
│  │  └─────────┘  └─────────┘  └─────────┘             │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## What's Included

### Global Customizations (applied to all accounts)
- Security baseline (EBS encryption, S3 block public access)
- IAM password policy
- CloudWatch log retention

### Account Customizations (WORKLOAD)
- VPC with public/private subnets
- Security groups baseline
- IAM roles for workloads

## Usage

1. Copy this pattern to your AFT repository
2. Update variables in `aft-global-customizations/terraform/variables.tf`
3. Customize account settings in `aft-account-customizations/WORKLOAD/terraform/variables.tf`
4. Create account requests in `aft-account-request/terraform/main.tf`

## Variables

### Global Customizations

| Variable | Description | Default |
|----------|-------------|---------|
| region | Primary AWS region | us-east-1 |
| enable_ebs_encryption | Enable EBS encryption by default | true |
| enable_s3_block_public | Block S3 public access | true |

### Account Customizations (WORKLOAD)

| Variable | Description | Default |
|----------|-------------|---------|
| vpc_cidr | VPC CIDR block | 10.0.0.0/16 |
| availability_zones | AZs for deployment | ["us-east-1a", "us-east-1b"] |
| enable_nat_gateway | Enable NAT Gateway | true |

## Deployment Order

1. Deploy global customizations (automatic via AFT)
2. Create account request
3. AFT provisions account with customizations
