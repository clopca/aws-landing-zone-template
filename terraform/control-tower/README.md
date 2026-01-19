# Control Tower Data Sources

This Terraform configuration provides data sources for referencing AWS resources created and managed by AWS Control Tower.

## Purpose

AWS Control Tower manages:
- AWS Organizations
- Organizational Units (OUs)
- Core accounts (Management, Log Archive, Audit)
- Guardrails (SCPs and Config Rules)

This module **does not create** these resources. Instead, it provides data sources to reference them in your Terraform configurations.

## Prerequisites

1. AWS Control Tower must be deployed in your Management account
2. Terraform must be run with credentials that have read access to AWS Organizations

## Usage

```hcl
module "control_tower" {
  source = "../control-tower"
}

# Use outputs in other resources
resource "aws_iam_role" "example" {
  # Reference the audit account
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${module.control_tower.audit_account_id}:root"
      }
      Action = "sts:AssumeRole"
    }]
  })
}
```

## Outputs

| Output | Description |
|--------|-------------|
| `organization_id` | AWS Organization ID |
| `management_account_id` | Management Account ID |
| `log_archive_account_id` | Log Archive Account ID |
| `audit_account_id` | Audit/Security Account ID |
| `security_ou_id` | Security OU ID |
| `infrastructure_ou_id` | Infrastructure OU ID |
| `workloads_ou_id` | Workloads OU ID |
| `sandbox_ou_id` | Sandbox OU ID |

## Why Data Sources?

1. **Avoid conflicts**: Creating Organizations/OUs via Terraform when Control Tower manages them causes drift
2. **Guardrail compliance**: Control Tower applies guardrails to OUs - Terraform-managed OUs miss these
3. **Single source of truth**: Control Tower console shows the authoritative state
4. **Update safety**: Control Tower updates won't conflict with Terraform state
