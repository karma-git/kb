provider "aws" {
  region = "eu-central-1"
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}

resource "aws_instance" "my_webserver" {
  ami           = "ami-043097594a7df80ec" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  tags = {
    Name        = "AmiWebServer"
    Project     = "Terraform Lesson"
    Description = "Procstinate website"
  }
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("deploy_nginx.sh")
}

resource "aws_security_group" "my_webserver" {
  name        = "allow_web"
  description = "Allow http/s inbound traffic"

  ingress {
    description = "http rule"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "https rule"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
