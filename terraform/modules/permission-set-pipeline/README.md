# Permission Set Pipeline Module

This module creates a CI/CD pipeline for managing IAM Identity Center permission sets using GitOps principles.

## Features

- **CodePipeline**: Automated pipeline for permission set changes
- **GitOps Workflow**: Changes triggered by repository commits
- **Manual Approval**: Optional approval stage before applying changes
- **Terraform Integration**: Uses Terraform for permission set management
- **Encrypted Artifacts**: S3 bucket with optional KMS encryption

## Architecture

```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌─────────────┐
│   GitHub    │───►│   Validate   │───►│     Plan     │───►│   Approval  │
│  (Source)   │    │  (CodeBuild) │    │  (CodeBuild) │    │  (Manual)   │
└─────────────┘    └──────────────┘    └──────────────┘    └──────┬──────┘
                                                                   │
                                                                   ▼
                                                           ┌─────────────┐
                                                           │    Apply    │
                                                           │  (CodeBuild)│
                                                           └─────────────┘
```

## Usage

```hcl
module "permission_set_pipeline" {
  source = "../../modules/permission-set-pipeline"

  name_prefix             = "myorg"
  codestar_connection_arn = "arn:aws:codestar-connections:us-east-1:123456789012:connection/xxx"
  repository_id           = "myorg/permission-sets"
  branch_name             = "main"
  permission_sets_path    = "terraform/permission-sets"

  enable_manual_approval = true
  approval_email         = "platform-team@example.com"

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

## Prerequisites

1. **CodeStar Connection**: Create a connection to your Git provider (GitHub, GitLab, etc.)
2. **Permission Sets Repository**: Repository containing Terraform code for permission sets
3. **IAM Identity Center**: IAM Identity Center must be enabled in your organization

## Repository Structure

Your permission sets repository should have this structure:

```
terraform/permission-sets/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── permission-sets/
    ├── admin.tf
    ├── developer.tf
    └── readonly.tf
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix for resource names | `string` | n/a | yes |
| codestar_connection_arn | CodeStar connection ARN | `string` | n/a | yes |
| repository_id | Repository ID (owner/repo) | `string` | n/a | yes |
| branch_name | Branch to monitor | `string` | `"main"` | no |
| permission_sets_path | Path to Terraform config | `string` | `"terraform/permission-sets"` | no |
| enable_manual_approval | Enable approval stage | `bool` | `true` | no |
| approval_email | Email for approvals | `string` | `""` | no |
| kms_key_arn | KMS key for encryption | `string` | `null` | no |
| terraform_version | Terraform version | `string` | `"1.5.7"` | no |

## Outputs

| Name | Description |
|------|-------------|
| pipeline_arn | CodePipeline ARN |
| pipeline_name | CodePipeline name |
| codebuild_project_arn | CodeBuild project ARN |
| artifacts_bucket_arn | S3 artifacts bucket ARN |
| approval_topic_arn | SNS approval topic ARN |

## Security Considerations

1. **Least Privilege**: CodeBuild role has minimal permissions for SSO management
2. **Encryption**: Artifacts encrypted at rest (optional KMS)
3. **Manual Approval**: Recommended for production changes
4. **Audit Trail**: CloudWatch logs for all pipeline executions
