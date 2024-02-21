terraform {
  backend "s3" {
    bucket = "tf-statefile-new"
    key    = "kubernetes-creation/eks-creation"
    region = "ap-south-1"
  }
}
