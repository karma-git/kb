provider "aws" {
        region = "eu-central-1"
}

resource "aws_instance" "example" {
  ami = "ami-043097594a7df80ec"
  instance_type = "t2.micro"
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
echo "Hello world from $(hostname -f)" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "terraform example"
  }

}

resource "aws_security_group" "example" {
  name = "allow http"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
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
    Name = "allow http"
  }
}
