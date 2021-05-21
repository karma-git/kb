# export TF_VAR_secret=supersecuredata
variable "aws_access_key_id" {
  description = "aws_access_key_id"
  type = string
}


variable "aws_secret_access_key" {
  description = "aws_secret_access_key"
  type = string
}


provider "aws" {
        access_key = var.aws_access_key_id
        secret_key = var.aws_secret_access_key
        region = "eu-central-1" # Frankfurt
}


resource "aws_instance" "my_ubuntu" {
  ami = "ami-05f7491af5eef733a" # Ubuntu Server 20.04 LTS
  instance_type = "t2.micro" # Free tier eligible ec2
  # count = 3 - qty of ec2 instances
}

resource "aws_instance" "my_amazon_linux" {
  ami = "ami-043097594a7df80ec" # Amazon Linux 2 AMI
  instance_type = "t2.micro" # Free tier eligible ec2
}
