variable "eks_role_name" {
  description = "Name of the IAM role for EKS service"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for public_subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for private_subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_availability_zone" {
  description = "availability zone for public_subnet"
  type        = string
  default     = "us-west-2a"
}

variable "private_subnet_availability_zone" {
  description = "availability zone for private_subnet"
  type        = string
  default     = "us-west-2b"
}