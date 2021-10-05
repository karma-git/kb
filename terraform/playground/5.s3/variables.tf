variable "aws_profile" {
  default = "aws"
}


variable "aws_region" {
  default = "us-east-2"
}

variable "bucket_prefix" {
  type    = string
  default = "terraform-s3-"
}

variable "tags" {
  type = map(any)
  default = {
    environment = "test"
    terraform   = "true"
  }
}

variable "versioning" {
  type    = bool
  default = false
}

variable "acl" {
  type    = string
  default = "private"
}
