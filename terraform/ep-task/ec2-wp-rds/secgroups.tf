resource "aws_security_group" "rds" {
  name = "RDS security group"

  ingress {
    from_port = 3306
    to_port = 3306
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
    Name = "ep-wp-rds-sg"
  }
}

resource "aws_security_group" "ec2" {
  name = "EC2 instance security group"

  ingress {
    from_port = 80
    protocol = "TCP"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ep-wp-ec2-sg"
  }
}