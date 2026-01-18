data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.name_prefix}-permission-set-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-permission-set-codebuild-role"
  })
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "S3Access"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*"
    ]
  }

  statement {
    sid    = "SSOAdmin"
    effect = "Allow"
    actions = [
      "sso:*",
      "sso-directory:*",
      "identitystore:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "IAMReadOnly"
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:GetPolicy",
      "iam:ListRoles",
      "iam:ListPolicies"
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.kms_key_arn != null ? [1] : []
    content {
      sid    = "KMSAccess"
      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey"
      ]
      resources = [var.kms_key_arn]
    }
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "${var.name_prefix}-permission-set-codebuild-policy"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "/aws/codebuild/${var.name_prefix}-permission-sets"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-permission-sets-logs"
  })
}

resource "aws_codebuild_project" "permission_sets" {
  name          = "${var.name_prefix}-permission-sets"
  description   = "Build project for IAM Identity Center permission sets"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TF_VERSION"
      value = var.terraform_version
    }

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = local.region
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOF
      version: 0.2
      phases:
        install:
          commands:
            - wget -q https://releases.hashicorp.com/terraform/$${TF_VERSION}/terraform_$${TF_VERSION}_linux_amd64.zip
            - unzip -q terraform_$${TF_VERSION}_linux_amd64.zip
            - mv terraform /usr/local/bin/
            - terraform version
        pre_build:
          commands:
            - cd ${var.permission_sets_path}
            - terraform init
        build:
          commands:
            - |
              case $TF_COMMAND in
                validate)
                  terraform validate
                  terraform fmt -check
                  ;;
                plan)
                  terraform plan -out=tfplan
                  ;;
                apply)
                  terraform apply -auto-approve tfplan
                  ;;
              esac
      artifacts:
        files:
          - '**/*'
    EOF
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-permission-sets"
  })
}
