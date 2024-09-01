generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}
EOF
}

terraform {
  source = "."

  backend "s3" {
    bucket         = "daniels-s3bucket-terraform-state"
    key            = "terraform/state/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }

  inputs = {
    bucket_name = "daniels-s3bucket"
  }
}

locals {
  environment = "DEV"
}

terragrunt {
  retryable_errors = ["Failed to lock state"]
  prevent_destroy  = true
  # Replace ACCOUNT_ID with your actual AWS account ID
  iam_role         = "arn:aws:iam::329082085800:role/TerragruntRole"
}
