# Custom Service Control Policies
#
# These SCPs extend Control Tower's guardrails with additional restrictions.
# Control Tower guardrails should be enabled first via the Control Tower console.
#
# These are CUSTOM SCPs that complement Control Tower guardrails.

# Deny accounts from leaving the organization (complements CT guardrails)
resource "aws_organizations_policy" "deny_leave_org" {
  name        = "${var.organization_name}-DenyLeaveOrganization"
  description = "Prevents accounts from leaving the organization"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyLeaveOrganization"
        Effect   = "Deny"
        Action   = "organizations:LeaveOrganization"
        Resource = "*"
      }
    ]
  })
}

# Require IMDSv2 for EC2 instances (defense in depth)
resource "aws_organizations_policy" "require_imdsv2" {
  name        = "${var.organization_name}-RequireIMDSv2"
  description = "Requires EC2 instances to use IMDSv2"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "RequireIMDSv2"
        Effect   = "Deny"
        Action   = "ec2:RunInstances"
        Resource = "arn:aws:ec2:*:*:instance/*"
        Condition = {
          StringNotEquals = {
            "ec2:MetadataHttpTokens" = "required"
          }
        }
      }
    ]
  })
}

# Deny most root user actions (complements CT guardrails)
resource "aws_organizations_policy" "deny_root_user" {
  name        = "${var.organization_name}-DenyRootUser"
  description = "Denies most actions by the root user"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyRootUser"
        Effect = "Deny"
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "sts:GetSessionToken",
          "iam:DeleteVirtualMFADevice",
          "iam:DeactivateMFADevice"
        ]
        Resource = "*"
        Condition = {
          StringLike = {
            "aws:PrincipalArn" = "arn:aws:iam::*:root"
          }
        }
      }
    ]
  })
}

# Region restriction (beyond CT guardrails)
resource "aws_organizations_policy" "restrict_regions" {
  count = length(var.scp_allowed_regions) > 0 ? 1 : 0

  name        = "${var.organization_name}-RestrictRegions"
  description = "Restricts operations to approved AWS regions"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyNonApprovedRegions"
        Effect = "Deny"
        NotAction = [
          "a4b:*",
          "acm:*",
          "aws-marketplace-management:*",
          "aws-marketplace:*",
          "aws-portal:*",
          "budgets:*",
          "ce:*",
          "chime:*",
          "cloudfront:*",
          "config:*",
          "cur:*",
          "directconnect:*",
          "ec2:DescribeRegions",
          "ec2:DescribeTransitGateways",
          "ec2:DescribeVpnGateways",
          "fms:*",
          "globalaccelerator:*",
          "health:*",
          "iam:*",
          "importexport:*",
          "kms:*",
          "mobileanalytics:*",
          "networkmanager:*",
          "organizations:*",
          "pricing:*",
          "route53:*",
          "route53domains:*",
          "route53-recovery-cluster:*",
          "route53-recovery-control-config:*",
          "route53-recovery-readiness:*",
          "s3:GetAccountPublic*",
          "s3:ListAllMyBuckets",
          "s3:ListMultiRegionAccessPoints",
          "s3:PutAccountPublic*",
          "shield:*",
          "sts:*",
          "support:*",
          "trustedadvisor:*",
          "waf-regional:*",
          "waf:*",
          "wafv2:*",
          "wellarchitected:*"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = var.scp_allowed_regions
          }
        }
      }
    ]
  })
}

# Attach SCPs to OUs managed by Control Tower
# Reference OUs by looking them up from Control Tower

resource "aws_organizations_policy_attachment" "deny_leave_org_root" {
  policy_id = aws_organizations_policy.deny_leave_org.id
  target_id = local.root_id
}

resource "aws_organizations_policy_attachment" "require_imdsv2_workloads" {
  count = lookup(local.ou_name_to_id, "Workloads", null) != null ? 1 : 0

  policy_id = aws_organizations_policy.require_imdsv2.id
  target_id = local.ou_name_to_id["Workloads"]
}

resource "aws_organizations_policy_attachment" "require_imdsv2_sandbox" {
  count = lookup(local.ou_name_to_id, "Sandbox", null) != null ? 1 : 0

  policy_id = aws_organizations_policy.require_imdsv2.id
  target_id = local.ou_name_to_id["Sandbox"]
}

resource "aws_organizations_policy_attachment" "restrict_regions_workloads" {
  count = length(var.scp_allowed_regions) > 0 && lookup(local.ou_name_to_id, "Workloads", null) != null ? 1 : 0

  policy_id = aws_organizations_policy.restrict_regions[0].id
  target_id = local.ou_name_to_id["Workloads"]
}
