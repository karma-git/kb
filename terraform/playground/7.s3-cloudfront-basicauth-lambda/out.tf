output "cdn_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "s3_name" {
  value = aws_s3_bucket.this.bucket
}

output "ssm_param" {
  value = aws_ssm_parameter.password.name
}
