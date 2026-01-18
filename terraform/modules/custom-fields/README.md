# AFT Custom Fields Module

Reads AFT account request metadata from SSM Parameter Store and provides structured outputs for use in account customization blueprints.

## Usage

```hcl
module "custom_fields" {
  source = "../../modules/custom-fields"

  read_environment         = true
  read_vpc_cidr            = true
  read_cost_center         = true
  read_owner               = true
  read_data_classification = true
  read_backup_enabled      = true

  additional_custom_fields = ["project_code", "compliance_framework"]

  default_environment = "development"
  default_vpc_cidr    = "10.0.0.0/16"
}

resource "aws_vpc" "main" {
  cidr_block = module.custom_fields.vpc_cidr

  tags = merge(
    module.custom_fields.tags,
    {
      Name = "main-vpc"
    }
  )
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| read_environment | Read environment custom field | `bool` | `true` | no |
| read_vpc_cidr | Read vpc_cidr custom field | `bool` | `true` | no |
| read_cost_center | Read cost_center custom field | `bool` | `false` | no |
| read_owner | Read owner custom field | `bool` | `false` | no |
| read_data_classification | Read data_classification custom field | `bool` | `false` | no |
| read_backup_enabled | Read backup_enabled custom field | `bool` | `false` | no |
| additional_custom_fields | List of additional custom field names to read | `list(string)` | `[]` | no |
| default_environment | Default environment if not specified | `string` | `"development"` | no |
| default_vpc_cidr | Default VPC CIDR if not specified | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| account_id | Account ID from AFT |
| environment | Environment (production, staging, development) |
| vpc_cidr | VPC CIDR block for this account |
| cost_center | Cost center for billing |
| owner | Account owner |
| data_classification | Data classification level |
| backup_enabled | Whether backup is enabled |
| custom_fields | Map of additional custom fields |
| tags | Common tags derived from custom fields |

## SSM Parameter Structure

AFT creates SSM parameters at:
```
/aft/account-request/custom-fields/<field_name>
```

This module reads these parameters and provides safe defaults if they don't exist.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |
