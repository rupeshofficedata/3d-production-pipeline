#############################################
# VPC – Network boundary for everything
#############################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  # Name helps identify resources in AWS console
  name = "shazam-vpc"

  # CIDR defines private IP range
  cidr = "10.0.0.0/16"

  # Availability zones for high availability
  azs = ["us-east-1a", "us-east-1b"]

  # Private subnets → EKS nodes live here
  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  # Public subnets → load balancers
  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true
}
