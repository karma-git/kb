provider "aws" {
  profile = var.profile_b
  region  = var.region_b
}


provider "aws" {
  profile = var.profile_a
  region  = var.region_a
  alias = "a"
}
