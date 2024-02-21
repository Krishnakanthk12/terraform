variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "opsverse-task"
}

variable "cluster_version" {
  description = "Version of the EKS cluster"
  type        = string
  default     = "1.23"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "eks_role_name" {
  description = "Name of the IAM role for EKS service"
  type        = string
  default     = "eks-cluster-role"
}