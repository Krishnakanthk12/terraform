module "eks" {
  source = "./modules"
  cluster_name = var.cluster_name
  eks_role_name = var.eks_role_name
  cluster_version = var.cluster_version
  vpc_cidr_block = var.vpc_cidr_block
}
