locals {
  region        = "eu-west-1"
  resource_name = "demo-s3"
  cdn_origin_id = "storageDemo"
  tags = {
    Name    = "demo-s3"
    Created = "terraform"
  }
  lambda_zip_path = "py/main.zip"
}

// S3

resource "aws_s3_bucket" "this" {
  bucket = local.resource_name
  acl    = "private"

  versioning {
    enabled = false
  }
  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// CDN

resource "aws_cloudfront_distribution" "this" {

  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.this.bucket_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Access to ${aws_s3_bucket.this.bucket} objects via CDN"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.bucket_domain_name

    lambda_function_association {
      event_type = "viewer-request"
      // TODO: it's like alpine:latest, whould we use | instead
      // lambda_arn   = "${aws_lambda_function.this.arn}:<version>"
      lambda_arn   = aws_lambda_function.this.qualified_arn
      include_body = false
    }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100" // NA & EUROPE

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = local.tags

}

// LAMBDA

resource "aws_lambda_function" "this" {
  provider = aws.va

  description = "http basic auth for CloudFront"

  function_name    = "AccessRequestLambda"
  role             = aws_iam_role.lambda.arn
  filename         = local.lambda_zip_path
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime          = "python3.9"

  /*
  Cloud Front couldn't have a lambda edge with configured envcurrentonment variables
  ref: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/edge-functions-restrictions.html#lambda-requcurrentements-lambda-function-configuration
  envcurrentonment {
    variables = {
      password = random_password.password.result
    }
  }
  */

  publish = true
  tags    = local.tags
}

// Secrets

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_ssm_parameter" "password" {
  name  = "${local.resource_name}-password"
  type  = "String"
  value = random_password.password.result
}
