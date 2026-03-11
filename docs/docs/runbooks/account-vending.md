---
sidebar_position: 1
---

# Account Vending Runbook

This runbook describes how to provision new AWS accounts using Account Factory for Terraform (AFT).

## Prerequisites

- [ ] Access to the AFT repository (CodeCommit or GitHub)
- [ ] Platform team approval for new account
- [ ] Account details: name, email, OU, cost center
- [ ] SSO user information for account owner

## Account Request Process

### Step 1: Gather Information

Collect the following information:

| Field | Example | Notes |
|-------|---------|-------|
| Account Name | `acme-prod-ecommerce` | Follow naming convention |
| Account Email | `aws+prod-ecommerce@acme.com` | Unique email per account |
| OU | `Production` | Must exist in organization |
| SSO User Email | `team-lead@acme.com` | Initial admin access |
| Cost Center | `CC-12345` | For billing allocation |
| Environment | `production` | prod, staging, dev, sandbox |
| Workload Type | `ecommerce` | Application category |

### Step 2: Create Account Request

1. Clone the AFT account requests repository:

```bash
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/aft-account-request
cd aft-account-request
```

2. Start from the canonical example in this repository:

```bash
cp /path/to/aws-landing-zone-template/terraform/aft/account-requests/account-request.tf.example \
   terraform/prod-ecommerce.tf
```

3. Add the account request configuration:

```hcl
# terraform/prod-ecommerce.tf
module "prod_ecommerce" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "aws+prod-ecommerce@acme.com"
    AccountName               = "acme-prod-ecommerce"
    ManagedOrganizationalUnit = "Production"
    SSOUserEmail              = "team-lead@acme.com"
    SSOUserFirstName          = "Team"
    SSOUserLastName           = "Lead"
  }

  account_tags = {
    Environment       = "production"
    CostCenter        = "CC-12345"
    Team              = "ecommerce"
    DataClassification = "confidential"
  }

  custom_fields = {
    workload_type      = "ecommerce"
    vpc_cidr           = "10.10.0.0/16"
    requires_tgw       = "true"
    compliance_scope   = "pci-dss"
  }

  account_customizations_name = "PROD-ECOMMERCE"
}
```

### Step 3: Create Account Customizations (Optional)

If the account needs specific customizations:

1. Create customization directory:

```bash
mkdir -p ../aft-account-customizations/PROD-ECOMMERCE/terraform
```

2. Add customization configuration:

```hcl
# aft-account-customizations/PROD-ECOMMERCE/terraform/main.tf
data "aws_ssm_parameter" "network_catalog" {
  name = "/org/network/catalog"
}

data "aws_ssm_parameter" "log_archive_catalog" {
  name = "/org/log-archive/catalog"
}

locals {
  network_catalog     = jsondecode(data.aws_ssm_parameter.network_catalog.value)
  log_archive_catalog = jsondecode(data.aws_ssm_parameter.log_archive_catalog.value)
}

module "vpc" {
  source = "../../../../modules/vpc"

  name                     = "prod-ecommerce"
  cidr_block               = local.custom_fields.vpc_cidr
  availability_zones       = ["us-east-1a", "us-east-1b", "us-east-1c"]
  create_transit_subnets   = true
  create_database_subnets  = false
  enable_nat_gateway       = true
  single_nat_gateway       = false
  enable_flow_logs         = true
  flow_log_destination_arn = local.log_archive_catalog.vpc_flow_logs_bucket_arn

  tags = local.tags
}

module "tgw_attachment" {
  count  = local.custom_fields.requires_tgw == "true" ? 1 : 0
  source = "../../../../modules/tgw-attachment"

  name                       = "prod-ecommerce"
  transit_gateway_id         = local.network_catalog.transit_gateway_id
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.transit_subnet_ids
  association_route_table_id = local.network_catalog.route_table_ids.production
  propagation_route_table_ids = [
    local.network_catalog.route_table_ids.production,
    local.network_catalog.route_table_ids.shared,
  ]
  spoke_route_table_ids = module.vpc.private_route_table_ids
  destination_cidrs     = ["10.0.0.0/8"]
  tags                  = local.tags
}
```

Pattern directories in this repository only provide runnable customization examples. Account-request examples are centralized under `terraform/aft/account-requests/`.

### Step 4: Submit Pull Request

1. Create a branch and commit:

```bash
git checkout -b account/prod-ecommerce
git add .
git commit -m "feat: request new account prod-ecommerce"
git push origin account/prod-ecommerce
```

2. Create Pull Request with:
   - Title: `Account Request: prod-ecommerce`
   - Description: Business justification and details
   - Reviewers: Platform team

### Step 5: Review and Approval

The platform team will review:

- [ ] Account naming follows conventions
- [ ] Email is unique and follows pattern
- [ ] OU is appropriate for workload
- [ ] Tags are complete
- [ ] Customizations are valid
- [ ] Cost allocation is set

### Step 6: Merge and Provision

After approval:

1. PR is merged to main branch
2. AFT pipeline triggers automatically
3. Control Tower provisions the account
4. Global customizations are applied
5. Account-specific customizations are applied

### Step 7: Verify Account

1. Check AFT pipeline status in CodePipeline
2. Verify account appears in AWS Organizations
3. Test SSO access
4. Verify baseline resources exist

```bash
# List accounts in OU
aws organizations list-accounts-for-parent \
  --parent-id ou-xxxx-xxxxxxxx

# Check account status
aws organizations describe-account \
  --account-id 123456789012
```

## Troubleshooting

### Pipeline Failed

1. Check CodePipeline execution details
2. Review CloudWatch Logs for Step Functions
3. Common issues:
   - Invalid email format
   - OU doesn't exist
   - Terraform syntax error

### Account Not Appearing

1. Check Control Tower account factory
2. Verify Service Catalog portfolio
3. Check for pending actions in Control Tower

### SSO Access Issues

1. Verify SSO user exists
2. Check permission set assignment
3. Verify account is enrolled in IAM Identity Center

## Rollback

To delete a vended account:

1. Remove the account request file
2. Create PR and merge
3. **Note**: AFT does not automatically delete accounts
4. Manually close account via Organizations console

## Related

- [AFT Module Documentation](../modules/aft)
- [Multi-Account Architecture](../architecture/multi-account)
- [Deployment Runbook](./deployment)
