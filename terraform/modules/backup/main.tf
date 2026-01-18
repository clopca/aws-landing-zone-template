# AWS Backup Vault
resource "aws_backup_vault" "main" {
  name        = "${var.name_prefix}-backup-vault"
  kms_key_arn = var.kms_key_arn

  tags = var.tags
}

# Backup Vault Policy for cross-account access
resource "aws_backup_vault_policy" "main" {
  count = var.enable_cross_account_backup ? 1 : 0

  backup_vault_name = aws_backup_vault.main.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCrossAccountBackup"
        Effect = "Allow"
        Principal = {
          AWS = var.source_account_ids
        }
        Action = [
          "backup:CopyIntoBackupVault"
        ]
        Resource = "*"
      }
    ]
  })
}

# Backup Plan
resource "aws_backup_plan" "main" {
  name = "${var.name_prefix}-backup-plan"

  dynamic "rule" {
    for_each = var.backup_rules
    content {
      rule_name         = rule.value.name
      target_vault_name = aws_backup_vault.main.name
      schedule          = rule.value.schedule
      start_window      = rule.value.start_window
      completion_window = rule.value.completion_window

      lifecycle {
        cold_storage_after = rule.value.cold_storage_after
        delete_after       = rule.value.delete_after
      }

      dynamic "copy_action" {
        for_each = rule.value.copy_to_vault_arn != null ? [1] : []
        content {
          destination_vault_arn = rule.value.copy_to_vault_arn
          lifecycle {
            delete_after = rule.value.copy_delete_after
          }
        }
      }
    }
  }

  tags = var.tags
}

# Backup Selection
resource "aws_backup_selection" "main" {
  name         = "${var.name_prefix}-backup-selection"
  plan_id      = aws_backup_plan.main.id
  iam_role_arn = aws_iam_role.backup.arn

  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = "STRINGEQUALS"
      key   = selection_tag.value.key
      value = selection_tag.value.value
    }
  }

  resources = var.resource_arns
}

# IAM Role for Backup
resource "aws_iam_role" "backup" {
  name = "${var.name_prefix}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "backup" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}
