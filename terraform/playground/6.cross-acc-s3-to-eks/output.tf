output "s3-role-arn" {
  value       = aws_iam_role.s3.arn
}

output "eks-role-arn" {
  value       = aws_iam_role.eks.arn
}

output "s3_name" {
  value       = aws_s3_bucket.s3.bucket
}
