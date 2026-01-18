# Security Baseline Module

This module implements account-level security baseline configurations for AWS accounts in the Landing Zone.

## Features

- **EBS Encryption by Default**: Automatically encrypt all new EBS volumes
- **S3 Public Access Block**: Block public access at the account level
- **IAM Password Policy**: Enforce strong password requirements

## Usage

```hcl
module "security_baseline" {
  source = "../../modules/security-baseline"

  # EBS Encryption
  enable_ebs_encryption = true

  # S3 Public Access Block
  enable_s3_block_public_access = true

  # IAM Password Policy
  enable_iam_password_policy = true
  password_min_length        = 14
  password_require_uppercase = true
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_symbols   = true
  password_max_age           = 90
  password_reuse_prevention  = 24
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_ebs_encryption | Enable EBS encryption by default | `bool` | `true` | no |
| enable_s3_block_public_access | Enable S3 account-level public access block | `bool` | `true` | no |
| enable_iam_password_policy | Enable IAM password policy | `bool` | `true` | no |
| password_min_length | Minimum password length | `number` | `14` | no |
| password_require_uppercase | Require uppercase letters in password | `bool` | `true` | no |
| password_require_lowercase | Require lowercase letters in password | `bool` | `true` | no |
| password_require_numbers | Require numbers in password | `bool` | `true` | no |
| password_require_symbols | Require symbols in password | `bool` | `true` | no |
| password_max_age | Password expiration in days (0 = never) | `number` | `90` | no |
| password_reuse_prevention | Number of previous passwords that cannot be reused | `number` | `24` | no |

## Outputs

| Name | Description |
|------|-------------|
| ebs_encryption_enabled | Whether EBS encryption by default is enabled |
| s3_public_access_blocked | Whether S3 public access is blocked at account level |
| iam_password_policy_enabled | Whether IAM password policy is configured |

## Security Best Practices

This module implements AWS security best practices:

1. **EBS Encryption**: All new EBS volumes are encrypted by default using AWS-managed keys
2. **S3 Public Access Block**: Prevents accidental public exposure of S3 buckets
3. **Password Policy**: Enforces CIS Benchmark-compliant password requirements

## Compliance Mapping

| Control | Framework |
|---------|-----------|
| EBS Encryption | CIS AWS 2.2.1, SOC 2 CC6.1 |
| S3 Public Access Block | CIS AWS 2.1.5, SOC 2 CC6.1 |
| Password Policy | CIS AWS 1.8-1.11, SOC 2 CC6.1 |

## Related Modules

- [IAM Module](../iam/) - For IAM Identity Center and cross-account roles
- [Organization Module](../../organization/) - For SCPs and organization-wide policies
