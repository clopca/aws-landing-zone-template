# Read AFT custom fields from SSM Parameter Store
# These parameters are created by AFT during account provisioning

data "aws_ssm_parameter" "account_id" {
  name = "/aft/account-request/custom-fields/account_id"
}

data "aws_ssm_parameter" "environment" {
  count = var.read_environment ? 1 : 0
  name  = "/aft/account-request/custom-fields/environment"
}

data "aws_ssm_parameter" "vpc_cidr" {
  count = var.read_vpc_cidr ? 1 : 0
  name  = "/aft/account-request/custom-fields/vpc_cidr"
}

data "aws_ssm_parameter" "cost_center" {
  count = var.read_cost_center ? 1 : 0
  name  = "/aft/account-request/custom-fields/cost_center"
}

data "aws_ssm_parameter" "owner" {
  count = var.read_owner ? 1 : 0
  name  = "/aft/account-request/custom-fields/owner"
}

data "aws_ssm_parameter" "data_classification" {
  count = var.read_data_classification ? 1 : 0
  name  = "/aft/account-request/custom-fields/data_classification"
}

data "aws_ssm_parameter" "backup_enabled" {
  count = var.read_backup_enabled ? 1 : 0
  name  = "/aft/account-request/custom-fields/backup_enabled"
}

# Custom parameters - read any additional custom fields
data "aws_ssm_parameter" "custom" {
  for_each = toset(var.additional_custom_fields)
  name     = "/aft/account-request/custom-fields/${each.value}"
}

locals {
  # Helper to safely get values with defaults
  environment         = var.read_environment ? try(data.aws_ssm_parameter.environment[0].value, var.default_environment) : var.default_environment
  vpc_cidr            = var.read_vpc_cidr ? try(data.aws_ssm_parameter.vpc_cidr[0].value, var.default_vpc_cidr) : var.default_vpc_cidr
  cost_center         = var.read_cost_center ? try(data.aws_ssm_parameter.cost_center[0].value, "") : ""
  owner               = var.read_owner ? try(data.aws_ssm_parameter.owner[0].value, "") : ""
  data_classification = var.read_data_classification ? try(data.aws_ssm_parameter.data_classification[0].value, "internal") : "internal"
  backup_enabled      = var.read_backup_enabled ? try(data.aws_ssm_parameter.backup_enabled[0].value, "false") == "true" : false
}
