# Multi-Region Basic Pattern

A disaster recovery-ready AFT pattern for deploying workload accounts across two AWS regions with automated backup and replication.

## What This Pattern Provides

- **Security Baseline**: EBS encryption, S3 public access blocking, IAM password policy
- **Multi-Region VPCs**: VPCs in primary and secondary regions with full networking
- **Cross-Region Backup**: AWS Backup with cross-region replication
- **S3 Replication**: Cross-region replication for data durability
- **IAM**: Account alias and basic IAM roles for workload access
- **Disaster Recovery**: Automated failover capabilities

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         Workload Account                                │
│                                                                          │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                    Security Baseline (Global)                     │  │
│  │  • EBS Encryption  • S3 Block Public Access  • IAM Password Policy│  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  ┌─────────────────────────────┐   ┌─────────────────────────────┐    │
│  │   Primary Region (us-east-1)│   │Secondary Region (us-west-2) │    │
│  │                              │   │                              │    │
│  │  ┌────────────────────────┐ │   │ ┌────────────────────────┐  │    │
│  │  │  VPC (10.10.0.0/16)    │ │   │ │  VPC (10.20.0.0/16)    │  │    │
│  │  │  • 3 AZs               │ │   │ │  • 3 AZs               │  │    │
│  │  │  • Public/Private      │ │   │ │  • Public/Private      │  │    │
│  │  │  • NAT Gateways        │ │   │ │  • NAT Gateways        │  │    │
│  │  │  • VPC Flow Logs       │ │   │ │  • VPC Flow Logs       │  │    │
│  │  └────────────────────────┘ │   │ └────────────────────────┘  │    │
│  │                              │   │                              │    │
│  │  ┌────────────────────────┐ │   │ ┌────────────────────────┐  │    │
│  │  │  AWS Backup Vault      │ │   │ │  AWS Backup Vault (DR) │  │    │
│  │  │  • Daily backups       │◄├───┤►│  • Cross-region copy   │  │    │
│  │  │  • 30-day retention    │ │   │ │  • 30-day retention    │  │    │
│  │  └────────────────────────┘ │   │ └────────────────────────┘  │    │
│  │                              │   │                              │    │
│  │  ┌────────────────────────┐ │   │ ┌────────────────────────┐  │    │
│  │  │  S3 Bucket (Primary)   │ │   │ │  S3 Bucket (Replica)   │  │    │
│  │  │  • Versioning enabled  │─┼───┼►│  • Replication target  │  │    │
│  │  │  • Encryption enabled  │ │   │ │  • Encryption enabled  │  │    │
│  │  └────────────────────────┘ │   │ └────────────────────────┘  │    │
│  └─────────────────────────────┘   └─────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────┘
```

## When to Use This Pattern

✅ **Use this pattern when:**
- Disaster recovery is required
- Multi-region deployment needed
- Data durability is critical
- RTO/RPO requirements exist
- Compliance requires geographic redundancy

❌ **Don't use this pattern when:**
- Single region is sufficient
- Cost optimization is primary concern
- DR capabilities not needed
- Simple workload without data persistence

## Variables to Customize

### Account Request (`aft-account-request/terraform/main.tf`)

```hcl
control_tower_parameters = {
  AccountEmail              = "workload-prod-dr@example.com"  # CHANGE THIS
  AccountName               = "workload-prod-dr"              # CHANGE THIS
  ManagedOrganizationalUnit = "Workloads"                     # CHANGE THIS
  SSOUserEmail              = "admin@example.com"             # CHANGE THIS
  SSOUserFirstName          = "Admin"
  SSOUserLastName           = "User"
}

custom_fields = {
  primary_vpc_cidr        = "10.10.0.0/16"      # CHANGE THIS
  secondary_vpc_cidr      = "10.20.0.0/16"      # CHANGE THIS - must not overlap
  primary_region          = "us-east-1"         # CHANGE THIS
  secondary_region        = "us-west-2"         # CHANGE THIS
  enable_replication      = "true"              # Set to "false" to disable S3 replication
  backup_schedule         = "cron(0 2 * * ? *)" # Daily at 2 AM UTC
  backup_retention_days   = "30"                # Retention period
}
```

### Custom Fields Available

| Field | Description | Default | Example |
|-------|-------------|---------|---------|
| `primary_vpc_cidr` | Primary VPC CIDR block | `10.10.0.0/16` | `10.10.0.0/16` |
| `secondary_vpc_cidr` | Secondary VPC CIDR block | `10.20.0.0/16` | `10.20.0.0/16` |
| `primary_region` | Primary AWS region | `us-east-1` | `us-east-1` |
| `secondary_region` | Secondary AWS region | `us-west-2` | `us-west-2` |
| `enable_replication` | Enable S3 cross-region replication | `true` | `false` |
| `backup_schedule` | Backup schedule (cron) | `cron(0 2 * * ? *)` | `cron(0 0 * * ? *)` |
| `backup_retention_days` | Backup retention period | `30` | `90` |

## Deployment Steps

### 1. Copy Pattern to AFT Repository

```bash
# Copy to your AFT account-customizations repository
cp -r terraform/patterns/multi-region-basic/aft-account-customizations/WORKLOAD \
      /path/to/aft-account-customizations/

# Copy to your AFT global-customizations repository
cp -r terraform/patterns/multi-region-basic/aft-global-customizations/terraform/* \
      /path/to/aft-global-customizations/terraform/

# Copy account request template
cp terraform/patterns/multi-region-basic/aft-account-request/terraform/main.tf \
   /path/to/aft-account-requests/terraform/workload-prod-dr.tf
```

### 2. Customize Account Request

Edit the account request file with your specific values:

```bash
cd /path/to/aft-account-requests/terraform
vim workload-prod-dr.tf
```

**Important**: Ensure `primary_region` and `secondary_region` are different!

### 3. Commit and Push

```bash
git add .
git commit -m "Add workload-prod-dr account request using multi-region-basic pattern"
git push
```

### 4. Monitor AFT Pipeline

AFT will automatically:
1. Create the account via Control Tower
2. Apply global customizations (security baseline)
3. Apply account customizations (VPCs, backup, replication)
4. Run API helpers (pre/post scripts)

Monitor in AWS Step Functions console.

## What Gets Deployed

### Global Customizations (All Accounts)
- Security baseline (EBS encryption, S3 blocking, IAM policy)
- IAM account alias

### Account Customizations (Per Account)
- **Primary Region**:
  - VPC with 3 AZs (public + private subnets)
  - NAT Gateways (one per AZ)
  - VPC Flow Logs
  - AWS Backup vault
  - S3 bucket with replication enabled

- **Secondary Region**:
  - VPC with 3 AZs (public + private subnets)
  - NAT Gateways (one per AZ)
  - VPC Flow Logs
  - AWS Backup vault (DR)
  - S3 replica bucket

- **Cross-Region**:
  - Backup replication from primary to secondary
  - S3 replication from primary to secondary

## Outputs

After deployment, the following outputs are available:

```hcl
account_id              # AWS Account ID
primary_vpc_id          # Primary VPC ID
primary_vpc_cidr        # Primary VPC CIDR block
secondary_vpc_id        # Secondary VPC ID
secondary_vpc_cidr      # Secondary VPC CIDR block
backup_vault_arn        # Primary backup vault ARN
replication_bucket_id   # S3 replication bucket ID
```

## Cost Estimate

Approximate monthly costs (us-east-1 + us-west-2):

| Resource | Quantity | Monthly Cost |
|----------|----------|--------------|
| VPCs | 2 | $0 |
| NAT Gateways | 6 (3 per region) | ~$194.40 |
| VPC Flow Logs | 2 | ~$20-100 (varies) |
| AWS Backup | 2 vaults | ~$50-200 (varies by data) |
| S3 Replication | 2 buckets | ~$20-100 (varies by data) |
| Data Transfer | Cross-region | ~$20-200 (varies) |
| **Total** | | **~$304-794/month** |

> **Cost Optimization Tips**:
> - Set `single_nat_gateway = true` to reduce NAT costs
> - Adjust `backup_retention_days` to reduce backup storage
> - Set `enable_replication = "false"` if S3 replication not needed
> - Use S3 Intelligent-Tiering for cost optimization

## Disaster Recovery

### RTO/RPO Targets

| Metric | Target | Notes |
|--------|--------|-------|
| **RPO** | 24 hours | Daily backups at 2 AM UTC |
| **RTO** | 4-8 hours | Manual failover to secondary region |

### Failover Procedure

1. **Verify Secondary Region**:
   ```bash
   aws ec2 describe-vpcs --region us-west-2 \
     --filters "Name=tag:Name,Values=workload-prod-dr-secondary"
   ```

2. **Restore from Backup** (if needed):
   ```bash
   aws backup start-restore-job \
     --region us-west-2 \
     --recovery-point-arn <arn> \
     --iam-role-arn <role-arn> \
     --metadata <metadata>
   ```

3. **Update DNS/Load Balancers**: Point traffic to secondary region

4. **Verify Application**: Test application in secondary region

### Failback Procedure

1. Resolve issues in primary region
2. Sync data from secondary to primary
3. Update DNS/Load Balancers to primary region
4. Monitor for issues

## Troubleshooting

### Replication Not Working

Check S3 replication configuration:
```bash
aws s3api get-bucket-replication \
  --bucket workload-prod-dr-data \
  --region us-east-1
```

Verify IAM role has correct permissions for replication.

### Backup Failing

Check AWS Backup job status:
```bash
aws backup list-backup-jobs \
  --by-backup-vault-name workload-prod-dr-backup \
  --region us-east-1
```

Verify backup plan and IAM role permissions.

### Cross-Region Costs High

- Review data transfer costs in Cost Explorer
- Consider reducing backup frequency
- Evaluate S3 replication necessity
- Use S3 Lifecycle policies to transition to cheaper storage classes

## Next Steps

After deployment:

1. **Test Failover**: Perform DR drill to validate failover procedures
2. **Configure Monitoring**: CloudWatch dashboards for both regions
3. **Implement Automation**: Lambda functions for automated failover
4. **Document Runbooks**: Create detailed DR runbooks for operations team
5. **Set Up Alerts**: CloudWatch alarms for backup failures, replication lag

## Related Patterns

- **single-region-basic**: For non-DR workloads
- **transit-gateway**: For hub-and-spoke networking across regions

## References

- [AWS Backup Documentation](https://docs.aws.amazon.com/aws-backup/)
- [S3 Cross-Region Replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html)
- [Multi-Region Architecture](https://aws.amazon.com/solutions/implementations/multi-region-application-architecture/)
- [Backup Module](../../modules/backup/)
- [Storage Module](../../modules/storage/)
