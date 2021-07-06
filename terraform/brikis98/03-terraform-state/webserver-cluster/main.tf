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

  # integration between ASG and ALB
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

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

resource "aws_lb" "example" {
  name = "alb-instance-webserver-cluster"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default_subnets.ids

  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found from aws_lb"
      status_code = "404"
    }
  }

  tags  = {
    Name = "lb-list-webserver-cluster"
  }
}

resource "aws_security_group" "alb" {
  name = "LB security group"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-lb-webserver-cluster"
  }
}

resource "aws_lb_target_group" "asg" {
  name = "tg-asg-webserver-cluster"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = "15"
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

