resource "aws_security_group" "this" {
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

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = var.ssh_key_name

  iam_instance_profile = aws_iam_instance_profile.this.id
  vpc_security_group_ids = [aws_security_group.this.id]

  #   provisioner "remote-exec" {
  #   script = "scripts/wait_for_instance.sh"

  #   connection {
  #     type = "ssh"
  #     user = "ubuntu"
  #     host = self.private_ip
  # 
  #   }

  # }
  # provisioner "local-exec" {
  #   command = ansible-playbook -i '${self.private_ip},' ansible/playbook.yml"
  # }
}
