# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "kubernetes_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.kubernetes_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "PUBLIC SUBNET"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.kubernetes_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "PRIVATE SUBNET"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "PUB RT"
  }
}
 
resource "aws_route_table_association" "public_subnetassociation" {
  subnet_id      = aws_subnet.public_subnet.id 
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_eip" "eip" {
  vpc      = true
}

resource "aws_nat_gateway" "tnat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NAT-GATEWAY"
  }
}


resource "aws_route_table" "private_routetable" {
  vpc_id = aws_vpc.kubernetes_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tnat.id
  }

  tags = {
    Name = "PRI RT"
  }
}

resource "aws_route_table_association" "private_subnetassociation" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_routetable.id
}

resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.kubernetes_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "PUBLIC SECURITY GROUP"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow TLS inbound traffic from Public security group"
  vpc_id      = aws_vpc.kubernetes_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["10.0.1.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "PRIVATE SECURITY GROUP"
  }
}