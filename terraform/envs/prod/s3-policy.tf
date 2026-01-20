#############################################
# IAM Policy – Allow access to SHAZAM S3 bucket
#############################################

resource "aws_iam_policy" "shazam_s3_policy" {
  name        = "shazam-s3-policy"
  description = "Allow SHAZAM pods to access asset S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.shazam_assets.s3_bucket_arn,
          "${module.shazam_assets.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}
