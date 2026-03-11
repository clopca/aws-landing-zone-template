provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "aws-landing-zone"
      Environment = "management"
      ManagedBy   = "terraform"
      Component   = "control-tower"
    }
  }
}
