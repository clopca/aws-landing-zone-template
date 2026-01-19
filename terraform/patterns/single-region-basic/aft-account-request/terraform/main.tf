module "workload_account" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "workload-prod@example.com"
    AccountName               = "workload-prod"
    ManagedOrganizationalUnit = "Workloads"
    SSOUserEmail              = "admin@example.com"
    SSOUserFirstName          = "Admin"
    SSOUserLastName           = "User"
  }

  account_tags = {
    Environment = "production"
    AccountName = "workload-prod"
    ManagedBy   = "AFT"
    Pattern     = "single-region-basic"
  }

  change_management_parameters = {
    change_requested_by = "Infrastructure Team"
    change_reason       = "New production workload account"
  }

  custom_fields = {
    vpc_cidr     = "10.10.0.0/16"
    requires_tgw = "false"
  }

  account_customizations_name = "WORKLOAD"
}
