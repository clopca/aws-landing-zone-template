---
sidebar_position: 1
---

# Organization Module

The Organization module manages AWS Organizations, Organizational Units (OUs), and Service Control Policies (SCPs).

## Overview

This module is deployed in the **Management Account** and creates:

- AWS Organization (if not exists)
- Organizational Unit hierarchy
- Service Control Policies
- Account baseline settings

## Usage

```hcl
module "organization" {
  source = "../modules/organization"

  organization_name = "acme-corp"
  
  organizational_units = {
    Security = {
      parent = "Root"
      accounts = ["Security", "Log Archive"]
    }
    Infrastructure = {
      parent = "Root"
      accounts = ["Network Hub", "Shared Services"]
    }
    Workloads = {
      parent = "Root"
      children = ["Production", "Non-Production"]
    }
    Production = {
      parent = "Workloads"
    }
    Non-Production = {
      parent = "Workloads"
    }
    Sandbox = {
      parent = "Root"
    }
  }

  scp_policies = {
    deny-leave-org = {
      targets = ["Root"]
    }
    require-imdsv2 = {
      targets = ["Workloads", "Sandbox"]
    }
    restrict-regions = {
      targets = ["Workloads"]
      allowed_regions = ["us-east-1", "us-west-2", "eu-west-1"]
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `organization_name` | Name for the organization | `string` | Yes |
| `organizational_units` | Map of OUs to create | `map(object)` | Yes |
| `scp_policies` | Map of SCPs to create and attach | `map(object)` | No |
| `enable_all_features` | Enable all organization features | `bool` | No |
| `aws_service_access_principals` | AWS services to enable | `list(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `organization_id` | AWS Organization ID |
| `organization_arn` | AWS Organization ARN |
| `root_id` | Root OU ID |
| `ou_ids` | Map of OU names to IDs |
| `scp_ids` | Map of SCP names to IDs |

## SCP Policies

### deny-leave-org

Prevents accounts from leaving the organization.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLeaveOrg",
      "Effect": "Deny",
      "Action": "organizations:LeaveOrganization",
      "Resource": "*"
    }
  ]
}
```

### require-imdsv2

Requires EC2 instances to use IMDSv2.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RequireIMDSv2",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "StringNotEquals": {
          "ec2:MetadataHttpTokens": "required"
        }
      }
    }
  ]
}
```

### restrict-regions

Restricts operations to approved AWS regions.

### deny-root-user

Denies actions by the root user (except specific allowed actions).

## File Structure

```
terraform/organization/
├── main.tf              # Organization and OUs
├── scps.tf              # Service Control Policies
├── iam-identity-center.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── backend.tf
└── terraform.tfvars.example
```

## Dependencies

- Must be the first module deployed
- Management account must have Organizations enabled
- IAM Identity Center requires organization

## Related

- [Multi-Account Architecture](../architecture/multi-account)
- [Security Model](../architecture/security-model)
- [AFT Module](./aft)
