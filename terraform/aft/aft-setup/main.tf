module "aft" {
  source = "github.com/aws-ia/terraform-aws-control_tower_account_factory?ref=1.12.0"

  ct_management_account_id    = var.ct_management_account_id
  log_archive_account_id      = var.log_archive_account_id
  audit_account_id            = var.audit_account_id
  aft_management_account_id   = var.aft_management_account_id
  ct_home_region              = var.ct_home_region
  tf_backend_secondary_region = var.tf_backend_secondary_region

  vcs_provider                                    = var.vcs_provider
  github_enterprise_url                           = var.github_enterprise_url
  account_request_repo_name                       = var.account_request_repo_name
  account_request_repo_branch                     = var.account_request_repo_branch
  global_customizations_repo_name                 = var.global_customizations_repo_name
  global_customizations_repo_branch               = var.global_customizations_repo_branch
  account_customizations_repo_name                = var.account_customizations_repo_name
  account_customizations_repo_branch              = var.account_customizations_repo_branch
  account_provisioning_customizations_repo_name   = var.account_provisioning_customizations_repo_name
  account_provisioning_customizations_repo_branch = var.account_provisioning_customizations_repo_branch

  terraform_version      = var.terraform_version
  terraform_distribution = var.terraform_distribution

  aft_feature_cloudtrail_data_events      = var.aft_feature_cloudtrail_data_events
  aft_feature_enterprise_support          = var.aft_feature_enterprise_support
  aft_feature_delete_default_vpcs_enabled = var.aft_feature_delete_default_vpcs_enabled
}
