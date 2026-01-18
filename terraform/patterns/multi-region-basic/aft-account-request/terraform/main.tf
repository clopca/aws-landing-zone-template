module "workload_account_multiregion" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "workload-mr@example.com"
    AccountName               = "Workload-MultiRegion-Production"
    ManagedOrganizationalUnit = "Workloads"
    SSOUserEmail              = "admin@example.com"
    SSOUserFirstName          = "Admin"
    SSOUserLastName           = "User"
  }

  account_tags = {
    Environment = "production"
    CostCenter  = "engineering"
    Project     = "landing-zone"
    DREnabled   = "true"
  }

  change_management_parameters = {
    change_requested_by = "Platform Team"
    change_reason       = "Multi-region account provisioning"
  }

  custom_fields = {
    primary_vpc_cidr   = "10.0.0.0/16"
    dr_vpc_cidr        = "10.1.0.0/16"
    primary_region     = "us-east-1"
    dr_region          = "us-west-2"
    environment        = "production"
    enable_nat_gateway = "true"
  }

  account_customizations_name = "WORKLOAD"
}
