provider "aws" {
        region = "eu-central-1"
}

resource "aws_instance" "example" {
  ami = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  user_data              = <<EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p 8080 &
EOF

  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "WebServer"
  }

}

resource "aws_security_group" "example" {
  name = "allow http"

  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow http"
  }
}
