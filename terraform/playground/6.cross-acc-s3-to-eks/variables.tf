locals {
  // oidc provider link w/o https prefix
  oidc = replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")
}

variable "s3_bucket_name" {
  type        = string
  description = "example S3 bucket name"
}

variable "eks_name" {
  type        = string
  description = "EKS cluster name. Expected that it has been already created in eks acc"
}

variable "sa" {
  type        = string
  default     = "demo-s3-eks-sa"
  description = "Service Account for Pod which need to access S3 bucket"
  // ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/
}

variable "sa_namespace" {
  type        = string
  default     = "default"
  description = "Namespace where we should create SA and Pod"
  // ref: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
}
