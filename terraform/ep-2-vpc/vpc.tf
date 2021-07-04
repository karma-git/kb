resource "aws_vpc" "ep-2" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "ep-2-vpc"
  }
}

resource "aws_internet_gateway" "ep-2" {
  vpc_id = aws_vpc.ep-2.id

  tags = {
    Name = "ep-2-igw"
  }
}

resource "aws_subnet" "ep-2-fe-a" {
  vpc_id = aws_vpc.ep-2.id
  cidr_block = var.fe_a
  availability_zone = format("%sa", var.region)
  map_public_ip_on_launch = true
  
  tags = {
    Name = "ep-2-fe-a"
  }
}

resource "aws_subnet" "ep-2-be-a" {
  vpc_id = aws_vpc.ep-2.id
  cidr_block = var.be_a
  availability_zone = format("%sa", var.region)

  tags = {
    Name = "ep-2-be-a"
  }
}

resource "aws_route_table" "ep-2-rt-fe-a" {
  vpc_id = aws_vpc.ep-2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ep-2.id
  }
  tags = {
    Name = "ep-2-rt-fe-a"
  }
}

resource "aws_route_table" "ep-2-rt-be-a" {
  vpc_id = aws_vpc.ep-2.id

  tags = {
    Name = "ep-2-rt-be-a"
  }
}

resource "aws_route_table_association" "ep-2-fe-a" {
  subnet_id = aws_subnet.ep-2-fe-a.id
  route_table_id = aws_route_table.ep-2-rt-fe-a.id
}

resource "aws_route_table_association" "ep-2-be-a" {
  subnet_id = aws_subnet.ep-2-be-a.id
  route_table_id = aws_route_table.ep-2-rt-be-a.id
}