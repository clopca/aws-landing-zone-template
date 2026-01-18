resource "aws_s3_bucket" "main" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    Name = var.bucket_name
  })
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count = var.enable_encryption ? 1 : 0

  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_id != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_id
    }
    bucket_key_enabled = var.kms_key_id != null
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  count = var.enable_public_access_block ? 1 : 0

  bucket = aws_s3_bucket.main.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket" "logging" {
  count = var.enable_logging && var.logging_bucket_name == null ? 1 : 0

  bucket        = "${var.bucket_name}-logs"
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    Name    = "${var.bucket_name}-logs"
    Purpose = "Access logging"
  })
}

resource "aws_s3_bucket_versioning" "logging" {
  count = var.enable_logging && var.logging_bucket_name == null ? 1 : 0

  bucket = aws_s3_bucket.logging[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  count = var.enable_logging && var.logging_bucket_name == null ? 1 : 0

  bucket = aws_s3_bucket.logging[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  count = var.enable_logging && var.logging_bucket_name == null ? 1 : 0

  bucket = aws_s3_bucket.logging[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "main" {
  count = var.enable_logging ? 1 : 0

  bucket = aws_s3_bucket.main.id

  target_bucket = var.logging_bucket_name != null ? var.logging_bucket_name : aws_s3_bucket.logging[0].id
  target_prefix = var.logging_prefix
}

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.main.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      dynamic "filter" {
        for_each = rule.value.prefix != null ? [1] : []
        content {
          prefix = rule.value.prefix
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration_days != null ? [1] : []
        content {
          days = rule.value.expiration_days
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [1] : []
        content {
          noncurrent_days = rule.value.noncurrent_version_expiration
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition_days != null ? [1] : []
        content {
          days          = rule.value.transition_days
          storage_class = rule.value.transition_storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_transition_days != null ? [1] : []
        content {
          noncurrent_days = rule.value.noncurrent_transition_days
          storage_class   = rule.value.noncurrent_storage_class
        }
      }
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "main" {
  count = var.enable_replication && var.replication_role_arn != null && var.replication_destination_bucket_arn != null ? 1 : 0

  depends_on = [aws_s3_bucket_versioning.main]

  bucket = aws_s3_bucket.main.id
  role   = var.replication_role_arn

  rule {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket        = var.replication_destination_bucket_arn
      storage_class = var.replication_destination_storage_class
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "main" {
  count = var.enable_object_lock ? 1 : 0

  bucket              = aws_s3_bucket.main.id
  object_lock_enabled = "Enabled"

  rule {
    default_retention {
      mode = var.object_lock_mode
      days = var.object_lock_days
    }
  }
}

data "aws_iam_policy_document" "secure_transport" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.main.arn,
      "${aws_s3_bucket.main.arn}/*"
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = var.bucket_policy != null ? var.bucket_policy : data.aws_iam_policy_document.secure_transport.json
}
