resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.name_prefix}-permission-set-artifacts-${local.account_id}"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-permission-set-artifacts"
  })
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${var.name_prefix}-permission-set-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-permission-set-pipeline-role"
  })
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    sid    = "S3Access"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*"
    ]
  }

  statement {
    sid    = "CodeBuildAccess"
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = [aws_codebuild_project.permission_sets.arn]
  }

  statement {
    sid    = "CodeStarConnectionAccess"
    effect = "Allow"
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = [var.codestar_connection_arn]
  }

  dynamic "statement" {
    for_each = var.enable_manual_approval ? [1] : []
    content {
      sid    = "SNSAccess"
      effect = "Allow"
      actions = [
        "sns:Publish"
      ]
      resources = [aws_sns_topic.approval[0].arn]
    }
  }
}

resource "aws_iam_role_policy" "codepipeline" {
  name   = "${var.name_prefix}-permission-set-pipeline-policy"
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_sns_topic" "approval" {
  count = var.enable_manual_approval ? 1 : 0

  name = "${var.name_prefix}-permission-set-approval"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-permission-set-approval"
  })
}

resource "aws_sns_topic_subscription" "approval_email" {
  count = var.enable_manual_approval && var.approval_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.approval[0].arn
  protocol  = "email"
  endpoint  = var.approval_email
}

resource "aws_codepipeline" "permission_sets" {
  name     = "${var.name_prefix}-permission-set-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"

    dynamic "encryption_key" {
      for_each = var.kms_key_arn != null ? [1] : []
      content {
        id   = var.kms_key_arn
        type = "KMS"
      }
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.repository_id
        BranchName       = var.branch_name
      }
    }
  }

  stage {
    name = "Validate"

    action {
      name             = "TerraformValidate"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["validate_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.permission_sets.name
        EnvironmentVariables = jsonencode([
          {
            name  = "TF_COMMAND"
            value = "validate"
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["plan_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.permission_sets.name
        EnvironmentVariables = jsonencode([
          {
            name  = "TF_COMMAND"
            value = "plan"
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

  dynamic "stage" {
    for_each = var.enable_manual_approval ? [1] : []
    content {
      name = "Approval"

      action {
        name     = "ManualApproval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          NotificationArn = aws_sns_topic.approval[0].arn
          CustomData      = "Please review the Terraform plan and approve to apply permission set changes."
        }
      }
    }
  }

  stage {
    name = "Apply"

    action {
      name            = "TerraformApply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ProjectName = aws_codebuild_project.permission_sets.name
        EnvironmentVariables = jsonencode([
          {
            name  = "TF_COMMAND"
            value = "apply"
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-permission-set-pipeline"
  })
}
