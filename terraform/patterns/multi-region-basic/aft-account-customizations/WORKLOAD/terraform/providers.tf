provider "aws" {
  region = var.primary_region

  default_tags {
    tags = merge(var.account_tags, {
      Project     = "aws-landing-zone"
      Environment = lookup(var.account_tags, "Environment", "workload")
      ManagedBy   = "terraform"
      Component   = "account-customization"
    })
  }
}

provider "aws" {
  alias  = "primary"
  region = var.primary_region

  default_tags {
    tags = merge(var.account_tags, {
      Project     = "aws-landing-zone"
      Environment = lookup(var.account_tags, "Environment", "workload")
      ManagedBy   = "terraform"
      Component   = "account-customization"
    })
  }
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  default_tags {
    tags = merge(var.account_tags, {
      Project     = "aws-landing-zone"
      Environment = lookup(var.account_tags, "Environment", "workload")
      ManagedBy   = "terraform"
      Component   = "account-customization"
    })
  }
}
