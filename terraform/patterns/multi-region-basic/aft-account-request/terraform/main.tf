module "workload_account_dr" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "workload-prod-dr@example.com"
    AccountName               = "workload-prod-dr"
    ManagedOrganizationalUnit = "Workloads"
    SSOUserEmail              = "admin@example.com"
    SSOUserFirstName          = "Admin"
    SSOUserLastName           = "User"
  }

  account_tags = {
    Environment = "production"
    AccountName = "workload-prod-dr"
    ManagedBy   = "AFT"
    Pattern     = "multi-region-basic"
  }

  change_management_parameters = {
    change_requested_by = "Infrastructure Team"
    change_reason       = "New production workload account with DR"
  }

  custom_fields = {
    primary_vpc_cidr      = "10.10.0.0/16"
    secondary_vpc_cidr    = "10.20.0.0/16"
    primary_region        = "us-east-1"
    secondary_region      = "us-west-2"
    enable_replication    = "true"
    backup_schedule       = "cron(0 2 * * ? *)"
    backup_retention_days = "30"
  }

  account_customizations_name = "WORKLOAD"
}
