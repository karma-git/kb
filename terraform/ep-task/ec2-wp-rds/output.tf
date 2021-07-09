output "default_subnets" {
  value = data.aws_subnet_ids.default_subnets.ids
}

output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
  description = "Endpoint of a RDS instance in address:port format"
}

output "ec2_ami" {
  value = data.aws_ami.ep_wp_ami.id
  description = "AMI for launching ec2 instances with installed wordpress"
}

output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
  description = "EC2 instance public ip"
}
