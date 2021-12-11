data "aws_caller_identity" "s3" {
  provider = aws.s3
}

data "aws_caller_identity" "eks" {
  provider = aws.eks
}

data "aws_eks_cluster" "eks" {
  provider = aws.eks

  name = var.eks_name
}
