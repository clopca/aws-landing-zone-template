# IAM Module

This module provides comprehensive IAM management for AWS Landing Zone deployments, including IAM Identity Center permission sets, cross-account roles, and security configurations.

## Features

- **IAM Identity Center Permission Sets**: Create and manage SSO permission sets
- **Cross-Account Roles**: Configure roles for cross-account access
- **Break-Glass User**: Emergency access IAM user (disabled by default)
- **Custom Policies**: Create organization-specific IAM policies
- **Service-Linked Roles**: Manage AWS service-linked roles
- **Password Policy**: Configure account-level password requirements

## Usage

```hcl
module "iam" {
  source = "../../modules/iam"

  name_prefix = "myorg"

  # IAM Identity Center Permission Sets
  create_permission_sets = true
  sso_instance_arn       = "arn:aws:sso:::instance/ssoins-1234567890abcdef"
  
  permission_sets = {
    DeveloperAccess = {
      description      = "Developer access with limited permissions"
      session_duration = "PT4H"
      managed_policies = [
        "arn:aws:iam::aws:policy/PowerUserAccess"
      ]
      inline_policy = null
    }
  }

  # Cross-Account Roles
  create_cross_account_roles = true
  trusted_account_ids        = ["123456789012", "234567890123"]
  require_mfa_for_cross_account = true

  cross_account_roles = {
    DeploymentRole = {
      description      = "Role for CI/CD deployments"
      managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
      inline_policy    = null
    }
  }

  # Break-Glass User (disabled by default)
  create_break_glass_user = false

  # Password Policy
  configure_password_policy = true
  password_policy = {
    minimum_password_length      = 14
    require_lowercase_characters = true
    require_uppercase_characters = true
    require_numbers              = true
    require_symbols              = true
    max_password_age             = 90
    password_reuse_prevention    = 24
  }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}
```

## Default Permission Sets

When `create_default_permission_sets = true`, the following permission sets are created:

| Permission Set | Description | Session Duration |
|----------------|-------------|------------------|
| AdministratorAccess | Full administrative access | 4 hours |
| ReadOnlyAccess | Read-only access to all services | 8 hours |
| PowerUserAccess | Full access except IAM/Organizations | 4 hours |
| SecurityAudit | Security audit access | 8 hours |
| ViewOnlyAccess | View-only access (more restrictive) | 8 hours |
| BillingAccess | Billing and cost management | 4 hours |

## Default Cross-Account Roles

When `create_default_cross_account_roles = true`, the following roles are created:

| Role | Description |
|------|-------------|
| OrganizationAccountAccessRole | Full admin access from management account |
| SecurityAuditRole | Security audit access from security account |
| ReadOnlyRole | Read-only access for monitoring |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name_prefix | Prefix for IAM resource names | `string` | n/a | yes |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |
| create_permission_sets | Whether to create permission sets | `bool` | `false` | no |
| sso_instance_arn | ARN of IAM Identity Center instance | `string` | `""` | no |
| permission_sets | Map of permission sets to create | `map(object)` | `{}` | no |
| create_default_permission_sets | Create default permission sets | `bool` | `true` | no |
| create_cross_account_roles | Whether to create cross-account roles | `bool` | `true` | no |
| trusted_account_ids | Account IDs that can assume roles | `list(string)` | `[]` | no |
| cross_account_roles | Map of cross-account roles to create | `map(object)` | `{}` | no |
| create_default_cross_account_roles | Create default cross-account roles | `bool` | `true` | no |
| require_mfa_for_cross_account | Require MFA for role assumption | `bool` | `true` | no |
| enable_permission_boundary | Attach permission boundary to roles | `bool` | `false` | no |
| permission_boundary_arn | ARN of permission boundary policy | `string` | `""` | no |
| create_break_glass_user | Create break-glass IAM user | `bool` | `false` | no |
| configure_password_policy | Configure account password policy | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| permission_set_arns | Map of custom permission set ARNs |
| default_permission_set_arns | Map of default permission set ARNs |
| cross_account_role_arns | Map of custom cross-account role ARNs |
| default_cross_account_role_arns | Map of default cross-account role ARNs |
| break_glass_user_arn | ARN of break-glass user (if created) |
| custom_policy_arns | Map of custom policy ARNs |

## Security Considerations

1. **MFA Requirement**: Cross-account roles require MFA by default
2. **Permission Boundaries**: Can be enforced on all roles
3. **Break-Glass User**: Disabled by default, enable only for emergency access
4. **Session Duration**: Default permission sets have appropriate session limits
5. **Password Policy**: Enforces strong password requirements by default
