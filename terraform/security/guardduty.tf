data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_organizations_organization" "current" {}

resource "aws_guardduty_detector" "main" {
  count = var.enable_guardduty ? 1 : 0

  enable                       = true
  finding_publishing_frequency = "SIX_HOURS"

  datasources {
    s3_logs {
      enable = var.guardduty_s3_protection
    }
    kubernetes {
      audit_logs {
        enable = var.guardduty_eks_protection
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.guardduty_malware_protection
        }
      }
    }
  }
}

resource "aws_guardduty_organization_admin_account" "main" {
  count = var.enable_guardduty ? 1 : 0

  admin_account_id = data.aws_caller_identity.current.account_id

  depends_on = [aws_guardduty_detector.main]
}

resource "aws_guardduty_organization_configuration" "main" {
  count = var.enable_guardduty ? 1 : 0

  auto_enable_organization_members = "ALL"
  detector_id                      = aws_guardduty_detector.main[0].id

  datasources {
    s3_logs {
      auto_enable = var.guardduty_s3_protection
    }
    kubernetes {
      audit_logs {
        enable = var.guardduty_eks_protection
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = var.guardduty_malware_protection
        }
      }
    }
  }

  depends_on = [aws_guardduty_organization_admin_account.main]
}
