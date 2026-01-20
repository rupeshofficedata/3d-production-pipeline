module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "shazam-eks"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  enable_irsa     = true

  eks_managed_node_groups = {
    default = {
      name           = "default-ng"
      instance_types = ["t2.micro"]
      min_size       = 2
      max_size       = 4
      desired_size   = 2
    }
  }

  tags = {
    Project = "shazam"
    Env     = "prod"
  }
}
