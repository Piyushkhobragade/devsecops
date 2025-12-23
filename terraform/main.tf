terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "my-first-dev-khobragade"
    key            = "terraform/state"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "my-first-dev"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "DevSecOps-Pipeline"
      ManagedBy   = "Terraform"
      Environment = var.environment
      CostCenter  = "Learning"
      Owner       = "piyush"
    }
  }
}
