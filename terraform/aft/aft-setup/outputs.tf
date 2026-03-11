output "aft_management_account_id" {
  description = "AFT management account ID"
  value       = module.aft.aft_management_account_id
}

output "ct_home_region" {
  description = "Control Tower home region"
  value       = module.aft.ct_home_region
}

output "account_request_repo_name" {
  description = "Account request repository name"
  value       = module.aft.account_request_repo_name
}

output "global_customizations_repo_name" {
  description = "Global customizations repository name"
  value       = module.aft.global_customizations_repo_name
}

output "account_customizations_repo_name" {
  description = "Account customizations repository name"
  value       = module.aft.account_customizations_repo_name
}

output "account_provisioning_customizations_repo_name" {
  description = "Account provisioning customizations repository name"
  value       = module.aft.account_provisioning_customizations_repo_name
}
