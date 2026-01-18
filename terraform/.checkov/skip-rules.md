# Checkov Skip Rules Documentation

This file documents the Checkov rules that are skipped and the justification for each.

## Skipped Rules

### S3 Bucket Rules

| Rule | Description | Justification |
|------|-------------|---------------|
| CKV_AWS_18 | S3 bucket logging | Handled by storage module with `enable_logging` variable |
| CKV_AWS_21 | S3 bucket versioning | Handled by storage module with `enable_versioning` variable |

### VPC Rules

| Rule | Description | Justification |
|------|-------------|---------------|
| CKV2_AWS_11 | VPC Flow Logs | Handled by VPC module with `enable_flow_logs` variable |

### EBS Rules

| Rule | Description | Justification |
|------|-------------|---------------|
| CKV_AWS_3 | EBS encryption | Handled by security-baseline module with `enable_ebs_encryption` |

### IAM Password Policy Rules

| Rule | Description | Justification |
|------|-------------|---------------|
| CKV_AWS_9 | Password minimum length | Handled by security-baseline module |
| CKV_AWS_10 | Password requires uppercase | Handled by security-baseline module |
| CKV_AWS_11 | Password requires lowercase | Handled by security-baseline module |
| CKV_AWS_12 | Password requires numbers | Handled by security-baseline module |
| CKV_AWS_13 | Password requires symbols | Handled by security-baseline module |
| CKV_AWS_14 | Password max age | Handled by security-baseline module |
| CKV_AWS_15 | Password reuse prevention | Handled by security-baseline module |
| CKV_AWS_16 | Password hard expiry | Handled by security-baseline module |

## Adding New Skip Rules

When adding a new skip rule:

1. Document the rule ID and description
2. Provide clear justification
3. Ensure the security control is implemented elsewhere
4. Update this file with the new entry
