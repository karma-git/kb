// PROVIDER
provider "aws" {
  region  = var.REGION
  profile = var.PROFILE
}

// VARIABLES

variable "REGION" {}

variable "PROFILE" {}

variable "KEY_NAME" {}

locals {
  PROJECT = "ASG example"
}

// DATA SOURCES

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// RESOURCES

resource "aws_security_group" "this" {
  name   = local.PROJECT
  vpc_id = data.aws_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "this" {
  name_prefix   = local.PROJECT
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  key_name        = var.KEY_NAME
  security_groups = [aws_security_group.this.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name                 = local.PROJECT
  launch_configuration = aws_launch_configuration.this.name

  vpc_zone_identifier = data.aws_subnet_ids.default.ids

  min_size         = 1
  max_size         = 2
  desired_capacity = 2

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      "key"                 = "Project"
      "value"               = local.PROJECT
      "propagate_at_launch" = true
    },
  ]
}
