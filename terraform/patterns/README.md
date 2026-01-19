# AFT Account Patterns

Pre-configured patterns for deploying AWS accounts using Account Factory for Terraform (AFT). These patterns provide opinionated, production-ready configurations based on common use cases.

## Available Patterns

| Pattern | Use Case | Regions | DR | Cost | Complexity |
|---------|----------|---------|-----|------|------------|
| [single-region-basic](./single-region-basic/) | Standard workloads | 1 | ❌ | $ | Low |
| [multi-region-basic](./multi-region-basic/) | DR-ready workloads | 2 | ✅ | $$$ | Medium |

## Pattern Selection Guide

### Decision Tree

```
Do you need disaster recovery capabilities?
│
├─ NO ──► Do you need multi-region deployment?
│         │
│         ├─ NO ──► single-region-basic
│         │
│         └─ YES ──► Consider multi-region-basic (without DR features)
│
└─ YES ──► multi-region-basic
```

### Detailed Comparison

#### single-region-basic

**Best for:**
- Development/staging environments
- Non-critical workloads
- Cost-sensitive deployments
- Getting started with AFT

**Includes:**
- ✅ Security baseline (EBS encryption, S3 blocking, IAM policy)
- ✅ VPC with multi-AZ (3 AZs)
- ✅ NAT Gateways
- ✅ VPC Flow Logs
- ✅ Basic IAM roles
- ❌ Cross-region backup
- ❌ S3 replication
- ❌ DR capabilities

**Cost:** ~$107-147/month

**RTO/RPO:** N/A (no DR)

---

#### multi-region-basic

**Best for:**
- Production workloads
- Mission-critical applications
- Compliance requirements (geographic redundancy)
- High availability requirements

**Includes:**
- ✅ Security baseline (EBS encryption, S3 blocking, IAM policy)
- ✅ VPCs in two regions (multi-AZ each)
- ✅ NAT Gateways (both regions)
- ✅ VPC Flow Logs (both regions)
- ✅ Basic IAM roles
- ✅ Cross-region backup (AWS Backup)
- ✅ S3 cross-region replication
- ✅ DR capabilities

**Cost:** ~$304-794/month

**RTO/RPO:** 
- RPO: 24 hours (daily backups)
- RTO: 4-8 hours (manual failover)

## Prerequisites

Before using these patterns, ensure you have:

1. **AFT Deployed**: Account Factory for Terraform must be set up
2. **AFT Repositories**: Access to AFT repositories:
   - `aft-account-customizations`
   - `aft-global-customizations`
   - `aft-account-requests`
3. **Terraform Modules**: Ensure required modules exist in `terraform/modules/`:
   - `security-baseline`
   - `vpc`
   - `iam`
   - `backup` (for multi-region)
   - `storage` (for multi-region)
4. **AWS Permissions**: Appropriate IAM permissions for AFT execution role
5. **Control Tower**: AWS Control Tower configured with OUs

## How to Use Patterns

### Step 1: Choose a Pattern

Review the comparison table above and select the pattern that matches your requirements.

### Step 2: Copy Pattern Files

Each pattern contains three directories:

```
pattern-name/
├── aft-account-customizations/WORKLOAD/  # Account-specific resources
├── aft-global-customizations/            # Global resources (all accounts)
└── aft-account-request/                  # Example account request
```

Copy these to your AFT repositories:

```bash
# Example for single-region-basic
cd terraform/patterns/single-region-basic

# Copy account customizations
cp -r aft-account-customizations/WORKLOAD \
      /path/to/aft-account-customizations/

# Copy global customizations (if not already present)
cp -r aft-global-customizations/terraform/* \
      /path/to/aft-global-customizations/terraform/

# Copy account request template
cp aft-account-request/terraform/main.tf \
   /path/to/aft-account-requests/terraform/my-account.tf
```

### Step 3: Customize Account Request

Edit the account request file with your specific values:

```bash
cd /path/to/aft-account-requests/terraform
vim my-account.tf
```

**Required changes:**
- `AccountEmail`: Unique email for the account
- `AccountName`: Descriptive account name
- `ManagedOrganizationalUnit`: Target OU in Control Tower
- `SSOUserEmail`: SSO user email
- Custom fields (VPC CIDRs, regions, etc.)

### Step 4: Commit and Push

```bash
git add .
git commit -m "Add new account request using <pattern-name> pattern"
git push
```

### Step 5: Monitor Deployment

AFT will automatically process the account request:

1. **Account Creation**: Control Tower creates the account
2. **Global Customizations**: Applied to all AFT-managed accounts
3. **Account Customizations**: Applied to specific account
4. **API Helpers**: Pre/post scripts executed

Monitor progress in:
- AWS Step Functions console
- AFT CodePipeline
- CloudWatch Logs

## Pattern Structure

Each pattern follows this structure:

```
pattern-name/
├── README.md                                    # Pattern documentation
├── aft-account-customizations/
│   └── WORKLOAD/
│       ├── terraform/
│       │   ├── main.tf                          # Main resources
│       │   ├── variables.tf                     # Input variables
│       │   ├── outputs.tf                       # Output values
│       │   └── versions.tf                      # Provider versions
│       └── api_helpers/
│           ├── pre-api-helpers.sh               # Pre-deployment script
│           └── post-api-helpers.sh              # Post-deployment script
├── aft-global-customizations/
│   └── terraform/
│       ├── main.tf                              # Global resources
│       ├── variables.tf                         # Input variables
│       ├── outputs.tf                           # Output values
│       └── versions.tf                          # Provider versions
└── aft-account-request/
    └── terraform/
        └── main.tf                              # Example account request
```

## Customization

### Modifying Patterns

You can customize patterns to fit your needs:

1. **Add Resources**: Edit `main.tf` to add additional resources
2. **Adjust Variables**: Modify `variables.tf` for new configuration options
3. **Update Scripts**: Customize `api_helpers/*.sh` for custom logic
4. **Change Modules**: Reference different modules from `terraform/modules/`

### Creating New Patterns

To create a new pattern:

1. Copy an existing pattern as a starting point
2. Modify resources in `main.tf`
3. Update `README.md` with pattern-specific documentation
4. Test thoroughly in a non-production environment
5. Document cost estimates and use cases

## Common Custom Fields

Custom fields are passed from account requests to customizations:

| Field | Description | Example |
|-------|-------------|---------|
| `vpc_cidr` | VPC CIDR block | `10.10.0.0/16` |
| `primary_vpc_cidr` | Primary region VPC CIDR | `10.10.0.0/16` |
| `secondary_vpc_cidr` | Secondary region VPC CIDR | `10.20.0.0/16` |
| `primary_region` | Primary AWS region | `us-east-1` |
| `secondary_region` | Secondary AWS region | `us-west-2` |
| `requires_tgw` | Attach to Transit Gateway | `true` or `false` |
| `enable_replication` | Enable S3 replication | `true` or `false` |
| `backup_schedule` | Backup schedule (cron) | `cron(0 2 * * ? *)` |
| `backup_retention_days` | Backup retention period | `30` |

## Best Practices

1. **Use Consistent Naming**: Follow naming conventions for accounts and resources
2. **Tag Everything**: Apply consistent tags via `account_tags`
3. **Document Changes**: Update pattern READMEs when customizing
4. **Test First**: Deploy to non-production OU first
5. **Version Control**: Track all changes in Git
6. **Cost Monitoring**: Set up AWS Budgets for new accounts
7. **Security Review**: Review security baseline settings
8. **Backup Testing**: Regularly test backup/restore procedures (multi-region)

## References

- [AWS Control Tower AFT Guide](https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html)
- [AFT Blueprints (AWS Labs)](https://github.com/awslabs/aft-blueprints)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
