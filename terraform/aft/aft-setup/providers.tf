terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "CHANGEME-terraform-state"
    key            = "aft/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.ct_home_region

  default_tags {
    tags = {
      Project     = "aws-landing-zone"
      Environment = "aft"
      ManagedBy   = "terraform"
      Module      = "aft-setup"
    }
  }
}
