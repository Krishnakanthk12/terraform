terraform {
  backend "s3" {
    bucket = "tf-statefile-new"
    key    = "kubernetes-creation/eks-creation"
    region = "us-west-1"
  }
}