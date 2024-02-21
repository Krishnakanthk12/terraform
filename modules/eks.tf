# Create the EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.23"

  vpc_config {
    subnet_ids = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
  }
}

# Create the node group for the EKS cluster
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_cluster_role.arn  # Use the ARN of the cluster role for nodes
  subnet_ids      = [aws_subnet.private_subnet.id]  # Only in private subnet
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}