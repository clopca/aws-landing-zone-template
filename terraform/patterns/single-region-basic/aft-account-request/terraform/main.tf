module "workload_account" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "workload@example.com"
    AccountName               = "Workload-Production"
    ManagedOrganizationalUnit = "Workloads"
    SSOUserEmail              = "admin@example.com"
    SSOUserFirstName          = "Admin"
    SSOUserLastName           = "User"
  }

  account_tags = {
    Environment = "production"
    CostCenter  = "engineering"
    Project     = "landing-zone"
  }

  change_management_parameters = {
    change_requested_by = "Platform Team"
    change_reason       = "Initial account provisioning"
  }

  custom_fields = {
    vpc_cidr           = "10.1.0.0/16"
    environment        = "production"
    enable_nat_gateway = "true"
  }

  account_customizations_name = "WORKLOAD"
}
