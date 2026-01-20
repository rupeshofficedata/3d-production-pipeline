#############################################
# S3 – Asset storage for SHAZAM pipeline
#############################################

module "shazam_assets" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "shazam-assets-prod"

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id      = "cleanup-old-versions"
      enabled = true

      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]

  tags = {
    Project = "shazam"
    Env     = "prod"
  }
}
