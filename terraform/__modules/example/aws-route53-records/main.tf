provider "aws" {
  profile = "mc-project"
  region  = "us-east-1"
}

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.42.0"
    }
  }
}

terraform {
  backend "s3" {
    profile        = "mc-project"
    region         = "us-east-1"
    bucket         = "mc-terraform-states"
    key            = "aws-route53-records.tfstate"
    dynamodb_table = "mc-terraform-locks"
  }
}
