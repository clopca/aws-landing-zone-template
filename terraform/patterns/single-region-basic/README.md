# Single Region Basic Pattern

A foundational AFT pattern for deploying workload accounts in a single AWS region with essential security and networking capabilities.

## What This Pattern Provides

- **Security Baseline**: EBS encryption, S3 public access blocking, IAM password policy
- **VPC**: Multi-AZ VPC with public and private subnets, NAT gateways, VPC Flow Logs
- **IAM**: Account alias and basic IAM roles for workload access
- **Compliance**: Meets baseline security requirements for most workloads

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Workload Account                         │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │              Security Baseline                      │    │
│  │  • EBS Encryption                                   │    │
│  │  • S3 Block Public Access                           │    │
│  │  • IAM Password Policy                              │    │
│  └────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │                    VPC (10.10.0.0/16)              │    │
│  │                                                     │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐        │    │
│  │  │   AZ-a   │  │   AZ-b   │  │   AZ-c   │        │    │
│  │  │          │  │          │  │          │        │    │
│  │  │ Public   │  │ Public   │  │ Public   │        │    │
│  │  │ Private  │  │ Private  │  │ Private  │        │    │
│  │  └──────────┘  └──────────┘  └──────────┘        │    │
│  │                                                     │    │
│  │  NAT Gateways: Multi-AZ                            │    │
│  │  VPC Flow Logs: Enabled                            │    │
│  └────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │                  IAM Roles                          │    │
│  │  • Account Alias                                    │    │
│  │  • Basic Workload Roles                             │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## When to Use This Pattern

✅ **Use this pattern when:**
- Deploying a new workload account
- Single region deployment is sufficient
- Standard security baseline is adequate
- No disaster recovery requirements
- Getting started with AFT

❌ **Don't use this pattern when:**
- Multi-region deployment required
- Disaster recovery capabilities needed
- Custom security requirements beyond baseline
- Complex networking (use Transit Gateway pattern instead)

## Variables to Customize

### Account Request (`aft-account-request/terraform/main.tf`)

```hcl
control_tower_parameters = {
  AccountEmail              = "workload-prod@example.com"  # CHANGE THIS
  AccountName               = "workload-prod"              # CHANGE THIS
  ManagedOrganizationalUnit = "Workloads"                  # CHANGE THIS
  SSOUserEmail              = "admin@example.com"          # CHANGE THIS
  SSOUserFirstName          = "Admin"
  SSOUserLastName           = "User"
}

custom_fields = {
  vpc_cidr     = "10.10.0.0/16"  # CHANGE THIS - must not overlap
  requires_tgw = "false"          # Set to "true" if Transit Gateway needed
}
```

### Custom Fields Available

| Field | Description | Default | Example |
|-------|-------------|---------|---------|
| `vpc_cidr` | VPC CIDR block | `10.10.0.0/16` | `10.20.0.0/16` |
| `requires_tgw` | Attach to Transit Gateway | `false` | `true` |

## Deployment Steps

### 1. Copy Pattern to AFT Repository

```bash
# Copy to your AFT account-customizations repository
cp -r terraform/patterns/single-region-basic/aft-account-customizations/WORKLOAD \
      /path/to/aft-account-customizations/

# Copy to your AFT global-customizations repository
cp -r terraform/patterns/single-region-basic/aft-global-customizations/terraform/* \
      /path/to/aft-global-customizations/terraform/

# Copy account request template
cp terraform/patterns/single-region-basic/aft-account-request/terraform/main.tf \
   /path/to/aft-account-requests/terraform/workload-prod.tf
```

### 2. Customize Account Request

Edit the account request file with your specific values:

```bash
cd /path/to/aft-account-requests/terraform
vim workload-prod.tf
```

### 3. Commit and Push

```bash
git add .
git commit -m "Add workload-prod account request using single-region-basic pattern"
git push
```

### 4. Monitor AFT Pipeline

AFT will automatically:
1. Create the account via Control Tower
2. Apply global customizations (security baseline)
3. Apply account customizations (VPC, IAM)
4. Run API helpers (pre/post scripts)

Monitor in AWS Step Functions console.

## What Gets Deployed

### Global Customizations (All Accounts)
- Security baseline (EBS encryption, S3 blocking, IAM policy)
- IAM account alias

### Account Customizations (Per Account)
- VPC with 3 AZs (public + private subnets)
- NAT Gateways (one per AZ)
- VPC Flow Logs
- Basic IAM roles

## Outputs

After deployment, the following outputs are available:

```hcl
account_id          # AWS Account ID
vpc_id              # VPC ID
vpc_cidr            # VPC CIDR block
private_subnet_ids  # List of private subnet IDs
public_subnet_ids   # List of public subnet IDs
```

## Cost Estimate

Approximate monthly costs (us-east-1):

| Resource | Quantity | Monthly Cost |
|----------|----------|--------------|
| VPC | 1 | $0 |
| NAT Gateways | 3 | ~$97.20 |
| VPC Flow Logs | 1 | ~$10-50 (varies) |
| **Total** | | **~$107-147/month** |

> **Cost Optimization**: Set `single_nat_gateway = true` in VPC module to reduce NAT Gateway costs to ~$32.40/month

## Troubleshooting

### Account Creation Fails

Check AFT Step Functions execution logs:
```bash
aws stepfunctions list-executions \
  --state-machine-arn <aft-state-machine-arn> \
  --status-filter FAILED
```

### VPC Not Created

1. Check Terraform state in AFT S3 bucket
2. Verify custom fields are set correctly
3. Check for CIDR conflicts with existing VPCs

### Module Not Found Errors

Ensure module paths are correct relative to AFT repository structure:
- Global customizations: `../../../../../modules/`
- Account customizations: `../../../../../../modules/`

## Next Steps

After deployment:

1. **Configure Transit Gateway** (if needed): Set `requires_tgw = "true"`
2. **Deploy Workloads**: Use private subnets for compute resources
3. **Add Monitoring**: CloudWatch dashboards, alarms
4. **Implement Backup**: Use AWS Backup for data protection

## Related Patterns

- **multi-region-basic**: For disaster recovery requirements
- **transit-gateway**: For hub-and-spoke networking

## References

- [AFT Documentation](https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html)
- [VPC Module](../../modules/vpc/)
- [Security Baseline Module](../../modules/security-baseline/)
