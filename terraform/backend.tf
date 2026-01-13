terraform {
  backend "s3" {
    bucket  = "shazam-terraform-state"
    key     = "shazam/prod/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

/*
Terraform will now:
  Create lock files in S3
  Block concurrent applies
  Release lock after apply completes
*/