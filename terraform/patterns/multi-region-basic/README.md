# Multi-Region Basic Pattern

A two-region deployment pattern with disaster recovery capabilities for production workloads.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           AWS Organization                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                         │
│  │ Management  │  │  Security   │  │ Log Archive │                         │
│  │   Account   │  │   Account   │  │   Account   │                         │
│  └─────────────┘  └─────────────┘  └─────────────┘                         │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────┐    │
│  │                    Workload Accounts                                │    │
│  │  ┌─────────────────────────┐    ┌─────────────────────────┐       │    │
│  │  │   Primary (us-east-1)   │    │     DR (us-west-2)      │       │    │
│  │  │  ┌─────┐  ┌─────┐      │    │  ┌─────┐  ┌─────┐       │       │    │
│  │  │  │ VPC │  │ S3  │──────┼────┼──│ S3  │  │ VPC │       │       │    │
│  │  │  └─────┘  └─────┘      │    │  └─────┘  └─────┘       │       │    │
│  │  │           Replication ─┼────┼─►                        │       │    │
│  │  └─────────────────────────┘    └─────────────────────────┘       │    │
│  └────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
```

## What's Included

### Global Customizations (applied to all accounts)
- Security baseline (EBS encryption, S3 block public access)
- IAM password policy
- CloudWatch log retention
- Cross-region backup configuration

### Account Customizations (WORKLOAD)
- VPC in primary region (us-east-1)
- VPC in DR region (us-west-2)
- S3 cross-region replication
- AWS Backup with cross-region copy

## Usage

1. Copy this pattern to your AFT repository
2. Update variables for primary and DR regions
3. Configure replication settings
4. Create account requests

## Variables

### Global Customizations

| Variable | Description | Default |
|----------|-------------|---------|
| primary_region | Primary AWS region | us-east-1 |
| dr_region | Disaster recovery region | us-west-2 |
| enable_cross_region_backup | Enable cross-region backup | true |

### Account Customizations (WORKLOAD)

| Variable | Description | Default |
|----------|-------------|---------|
| primary_vpc_cidr | Primary VPC CIDR | 10.0.0.0/16 |
| dr_vpc_cidr | DR VPC CIDR | 10.1.0.0/16 |
| enable_s3_replication | Enable S3 cross-region replication | true |

## DR Capabilities

- **RTO**: < 4 hours (with pre-provisioned DR infrastructure)
- **RPO**: < 1 hour (with S3 replication and AWS Backup)

## Cost Considerations

This pattern incurs additional costs for:
- NAT Gateways in both regions
- S3 cross-region replication
- AWS Backup cross-region copies
- VPC resources in DR region

Consider using `single-region-basic` if DR is not required.
