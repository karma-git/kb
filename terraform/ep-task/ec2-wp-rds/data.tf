data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnet_ids" "default_subnets" {
  vpc_id = data.aws_vpc.default_vpc.id
}

data "aws_ami" "ep_wp_ami" {
  owners           = ["self"]
  most_recent = true

  tags = {
    Name = "ep-wp-ami"
  }
}