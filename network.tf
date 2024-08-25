

## Crating AWS VPC for  EC2 instances

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

## Crating AWS 2 subnet 

resource "aws_subnet" "primary_cidr" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/18"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "jenkins-terraform"
  }
}

resource "aws_subnet" "secondary_cidr" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/18"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "jenkins-terraform"
  }
}




resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
}




resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "subnet_primary" {
  subnet_id      = aws_subnet.primary_cidr.id
  route_table_id = aws_route_table.my_route_table.id

}

resource "aws_route_table_association" "subnet_secondory" {
  subnet_id      = aws_subnet.secondary_cidr.id
  route_table_id = aws_route_table.my_route_table.id
}

