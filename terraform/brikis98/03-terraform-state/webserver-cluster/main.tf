provider "aws" {
        region = "eu-central-1"
}

resource "aws_launch_configuration" "example" {
  name = "lc-webserver-cluster"

  image_id = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"

  user_data              = <<EOF
#!/bin/bash
echo "Hello world from $(hostname -f)" > index.html
nohup busybox httpd -f -p ${var.server_port} &
EOF

  security_groups = [aws_security_group.example.id]
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  name = "asg-webserver-cluster"

  launch_configuration = aws_launch_configuration.example.id
  vpc_zone_identifier = data.aws_subnet_ids.default_subnets.ids

  min_size = 2
  max_size = 4
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "asg-webserver-cluster"
  }
}

resource "aws_security_group" "example" {
  name = "allow http"

  ingress {
    from_port = var.server_port
    protocol = "tcp"
    to_port = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-instance-webserver-cluster"
  }
}

data "aws_vpc" "default_vpc" {
  default = true
  /* how to create data?
  data "<PROVIDER>_<TYPE>" "<NAME>" {
      [CONFIG ...]
  }

  how to ask data?
  data.<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>
  data.aws_vpc.default_vpc.id
  */
}

data "aws_subnet_ids" "default_subnets" {
  vpc_id = data.aws_vpc.default_vpc.id
}