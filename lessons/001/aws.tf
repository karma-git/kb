// -------------------------------------------------------
// Provider

provider "aws" {
  region  = "eu-west-1"
  # region  = "eu-south-1"
  profile = var.aws_named_profile
}

// -------------------------------------------------------
// SSH keys, network settings

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] // Canonical

  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 20.04 LTS, amd64 focal image build on*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_security_group" "this" {
  name        = "${local.author}-sg"
  description = "Allow ssh and web on port 80, and answer to everyone"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    // ssh
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    // web
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    // Allow outgoing traffic from all ports
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${local.author}-ansible"
  public_key = file(local.ssh.public_key_path)
}

// -------------------------------------------------------
// VM

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.this.id]
  availability_zone      = "eu-west-1b"

  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name

  provisioner "remote-exec" {
    script = <<EOF
      #!/bin/bash

      while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
        echo -e "\033[1;36mWaiting for cloud-init..."
        sleep 1
      done
    EOF

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(local.ssh.private_key_path)
    }
  }

  provisioner "local-exec" {
    command = <<EOF
        ansible-playbook \
          --inventory '${self.public_ip},' \
          --private-key ${local.ssh.private_key_path} \
          --user ubuntu \
          ./playbook.yml
        EOF

  }
  tags = {
    Name = "${local.author}-nginx"
  }
}

output "aws_nginx" {
  value = aws_instance.this.public_ip
}
