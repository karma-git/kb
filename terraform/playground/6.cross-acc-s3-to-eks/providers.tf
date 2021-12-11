provider "aws" {
  profile = "profile-s3"
  region  = "us-east-2"

  alias = "s3"
}


provider "aws" {
  profile = "profile-eks"
  region  = "us-east-2"

  alias = "eks"
}
