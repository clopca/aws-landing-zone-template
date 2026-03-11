provider "aws" {
  default_tags {
    tags = merge(var.account_tags, {
      Project     = "aws-landing-zone"
      Environment = lookup(var.account_tags, "Environment", "workload")
      ManagedBy   = "terraform"
      Component   = "account-provisioning"
    })
  }
}
