data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "cdn" {
  statement {
    sid = "S3GetObjectForCloudFront"

    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.this.bucket}/*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.this.iam_arn}"]
    }
  }
}

data "archive_file" "lambda" {
  type = "zip"

  source_dir  = "py"
  output_path = local.lambda_zip_path
}
