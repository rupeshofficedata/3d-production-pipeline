#############################################
# IRSA – Pod-level access to S3
#############################################

module "shazam_irsa_s3" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "shazam-s3-access"

  # Attach the policy we created above
  role_policy_arns = {
    s3 = aws_iam_policy.shazam_s3_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["shazam:shazam-api"]
    }
  }
}
