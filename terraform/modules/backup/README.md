# AWS Backup Module

Terraform module for creating AWS Backup resources including vaults, plans, and selections.

## Features

- Backup vault with optional KMS encryption
- Cross-account backup support
- Flexible backup rules with lifecycle policies
- Tag-based resource selection
- IAM role with AWS managed policies

## Usage

```hcl
module "backup" {
  source = "../../modules/backup"

  name_prefix = "production"
  kms_key_arn = aws_kms_key.backup.arn

  backup_rules = [
    {
      name         = "daily"
      schedule     = "cron(0 5 ? * * *)"
      delete_after = 35
    },
    {
      name               = "weekly"
      schedule           = "cron(0 5 ? * 1 *)"
      delete_after       = 90
      cold_storage_after = 30
    }
  ]

  selection_tags = [
    {
      key   = "Backup"
      value = "true"
    }
  ]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Cross-Account Backup

```hcl
module "backup_central" {
  source = "../../modules/backup"

  name_prefix                 = "central"
  enable_cross_account_backup = true
  source_account_ids = [
    "111111111111",
    "222222222222"
  ]

  backup_rules = [
    {
      name         = "daily"
      schedule     = "cron(0 5 ? * * *)"
      delete_after = 35
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name_prefix | Prefix for resource names | string | - | yes |
| kms_key_arn | KMS key ARN for backup vault encryption | string | null | no |
| enable_cross_account_backup | Enable cross-account backup | bool | false | no |
| source_account_ids | Account IDs allowed to copy backups | list(string) | [] | no |
| backup_rules | List of backup rules | list(object) | See variables.tf | no |
| selection_tags | Tags to select resources for backup | list(object) | [{"key": "Backup", "value": "true"}] | no |
| resource_arns | Specific resource ARNs to backup | list(string) | [] | no |
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| vault_arn | Backup vault ARN |
| vault_name | Backup vault name |
| plan_id | Backup plan ID |
| plan_arn | Backup plan ARN |
| role_arn | Backup IAM role ARN |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |
