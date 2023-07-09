provider "aws" {
  # profile = var.aws_profile
  region  = var.aws_region
}

data "aws_caller_identity" "current" {}


resource "aws_s3_bucket" "this" {
  bucket_prefix = var.bucket_prefix
  acl           = var.acl

  versioning {
    enabled = var.versioning
  }

  tags = var.tags
}
