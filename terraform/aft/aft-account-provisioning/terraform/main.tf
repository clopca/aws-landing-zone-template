data "aws_caller_identity" "current" {}

locals {
  account_id    = data.aws_caller_identity.current.account_id
  account_email = try(var.control_tower_parameters["AccountEmail"], "")
  account_name  = try(var.control_tower_parameters["AccountName"], "")
  ou_name       = try(var.control_tower_parameters["ManagedOrganizationalUnit"], "")
}

resource "aws_ssm_parameter" "account_info" {
  name = "/org/accounts/${local.account_id}/info"
  type = "String"
  value = jsonencode({
    account_id    = local.account_id
    account_name  = local.account_name
    account_email = local.account_email
    ou            = local.ou_name
    tags          = var.account_tags
    custom_fields = var.custom_fields
    provisioned   = timestamp()
  })

  lifecycle {
    ignore_changes = [value]
  }
}
