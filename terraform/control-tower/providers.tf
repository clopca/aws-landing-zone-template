provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = "landing-zone"
      Module    = "control-tower"
    }
  }
}
