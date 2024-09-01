terraform {
  source = "../terraform"

  extra_arguments "bucket_name" {
    commands = ["init", "plan", "apply"]
    arguments = ["-var", "bucket_name=daniels-s3bucket"]
  }
}

inputs = {
  bucket_name = "daniels-s3bucket"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "daniels-s3bucket-terraform-state"
    key            = "terraform/state/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

locals {
  environment = "DEV"
}

# You can remove this block if it is not supported
# or upgrade to a version of Terragrunt that supports it.
#terragrunt {
#  retryable_errors = ["Failed to lock state"]
#  prevent_destroy  = true
#  iam_role         = "arn:aws:iam::ACCOUNT_ID:role/TerragruntRole"
#}
