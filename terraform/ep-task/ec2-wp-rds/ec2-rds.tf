resource "aws_db_instance" "rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.dbname
  username               = var.username
  password               = var.password
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true

  tags = {
    Name = "ep-wp-rds"
  }
}

resource "aws_instance" "ec2" {
  ami = data.aws_ami.ep_wp_ami.id
  instance_type = "t2.micro"

  depends_on = [
  aws_db_instance.rds,
  ]

  vpc_security_group_ids = [aws_security_group.ec2.id]

//  provisioner "file" {
//  source = "files/wp-config.php"
//  destination = "/var/www/html/wp-config.ph"
//}

  user_data              = <<EOF
#!/bin/bash
sed -i 's/localhost/${aws_db_instance.rds.endpoint}/g' /var/www/html/wp-config.php
systemctl restart httpd
EOF

  tags = {
    Name = "ep-wp-ec2"
  }

}

