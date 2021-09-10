output "ec2_a_public_ip" {
  value = aws_instance.this.public_ip
}
