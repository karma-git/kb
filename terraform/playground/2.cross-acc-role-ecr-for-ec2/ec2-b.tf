resource "aws_security_group" "b" {
  name = "allow ssh"
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "b" {
  key_name   = var.key_name
  public_key = var.pub_key
}

resource "aws_instance" "b" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = aws_key_pair.b.key_name

  iam_instance_profile   = aws_iam_instance_profile.b.id
  vpc_security_group_ids = [aws_security_group.b.id]

}
