variable  "region" {
  description = "default region"
  default = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR for vpc"
  default = "10.1.0.0/16"
}

variable "fe_a" {
  description = "public subnet for the AZ a"
  default = "10.1.1.0/24"
}

variable "be_a" {
  description = "private subnet for the AZ a"
  default = "10.1.2.0/24"
}
