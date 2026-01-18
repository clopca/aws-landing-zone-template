# Storage Module

This module creates secure S3 buckets with AWS best practices for Landing Zone deployments.

## Features

- **Server-Side Encryption**: SSE-S3 or SSE-KMS encryption
- **Versioning**: Enabled by default for data protection
- **Access Logging**: Optional logging to separate bucket
- **Public Access Block**: All public access blocked by default
- **Lifecycle Rules**: Configurable object lifecycle management
- **Cross-Region Replication**: Optional replication for DR
- **Object Lock**: Optional WORM compliance support
- **Secure Transport**: Enforces HTTPS-only access

## Usage

```hcl
module "storage" {
  source = "../../modules/storage"

  bucket_name = "my-secure-bucket"

  enable_versioning  = true
  enable_encryption  = true
  enable_logging     = true

  lifecycle_rules = [
    {
      id                            = "archive-old-versions"
      enabled                       = true
      noncurrent_version_expiration = 90
      transition_days               = 30
      transition_storage_class      = "STANDARD_IA"
    }
  ]

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

## With KMS Encryption

```hcl
module "storage" {
  source = "../../modules/storage"

  bucket_name       = "my-kms-encrypted-bucket"
  enable_encryption = true
  kms_key_id        = "alias/my-kms-key"  # or use KMS key ARN

  tags = {
    Environment = "production"
  }
}
```

## With Cross-Region Replication

```hcl
module "storage" {
  source = "../../modules/storage"

  bucket_name        = "my-replicated-bucket"
  enable_replication = true
  replication_role_arn              = aws_iam_role.replication.arn
  replication_destination_bucket_arn = "arn:aws:s3:::my-destination-bucket"

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket_name | Name of the S3 bucket | `string` | n/a | yes |
| enable_versioning | Enable versioning | `bool` | `true` | no |
| enable_encryption | Enable server-side encryption | `bool` | `true` | no |
| kms_key_id | KMS key ID for SSE-KMS | `string` | `null` | no |
| enable_logging | Enable access logging | `bool` | `false` | no |
| logging_bucket_name | Existing bucket for logs | `string` | `null` | no |
| enable_public_access_block | Block all public access | `bool` | `true` | no |
| lifecycle_rules | List of lifecycle rules | `list(object)` | `[]` | no |
| enable_replication | Enable cross-region replication | `bool` | `false` | no |
| enable_object_lock | Enable object lock (WORM) | `bool` | `false` | no |
| force_destroy | Allow destroying non-empty bucket | `bool` | `false` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | ID of the S3 bucket |
| bucket_arn | ARN of the S3 bucket |
| bucket_domain_name | Domain name of the bucket |
| bucket_regional_domain_name | Regional domain name |
| logging_bucket_id | ID of logging bucket (if created) |
| logging_bucket_arn | ARN of logging bucket (if created) |

## Security Features

1. **HTTPS Only**: Bucket policy denies non-SSL requests
2. **Public Access Blocked**: All public access settings blocked by default
3. **Encryption**: Server-side encryption enabled by default
4. **Versioning**: Protects against accidental deletion
5. **Object Lock**: Optional WORM compliance for regulatory requirements
