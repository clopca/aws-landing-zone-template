terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"
    }
  }

  backend "s3" {
    key     = "aft/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = var.ct_home_region

  default_tags {
    tags = {
      Project     = "aws-landing-zone"
      Environment = "aft"
      ManagedBy   = "terraform"
      Component   = "aft-setup"
    }
  }
}
