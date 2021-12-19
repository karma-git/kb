provider "aws" {
  region  = "eu-west-1"
  profile = "your-profile"
}

provider "aws" {
  region  = "us-east-1"
  profile = "your-profile"

  // lambda edge function should be deployed in Virginia
  // ref: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/edge-functions-restrictions.html
  alias = "va"
}
