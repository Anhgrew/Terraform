
data "aws_availability_zones" "available" {
  state = "available"
}

# Main  vpc
resource "aws_vpc" "elearning_vpc" {
  cidr_block       = var.ELEARNING_VPC_CIDR_BLOC
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc"
  }
}

# Public subnets

#public Subnet 1
resource "aws_subnet" "elearning_vpc_public_subnet_1" {
  vpc_id     = aws_vpc.elearning_vpc.id
  cidr_block = var.ELEARNING_VPC_PUBLIC_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-elearning-vpc-public-subnet-1"
  }
}
#public Subnet 2
resource "aws_subnet" "elearning_vpc_public_subnet_2" {
  vpc_id     = aws_vpc.elearning_vpc.id
  cidr_block = var.ELEARNING_VPC_PUBLIC_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-elearning-vpc-public-subnet-2"
  }
}

# private subnet 1
resource "aws_subnet" "elearning_vpc_private_subnet_1" {
  vpc_id     = aws_vpc.elearning_vpc.id
  cidr_block = var.ELEARNING_VPC_PRIVATE_SUBNET1_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.ENVIRONMENT}-elearning-vpc-private-subnet-1"
  }
}
# private subnet 2
resource "aws_subnet" "elearning_vpc_private_subnet_2" {
  vpc_id     = aws_vpc.elearning_vpc.id
  cidr_block = var.ELEARNING_VPC_PRIVATE_SUBNET2_CIDR_BLOCK
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.ENVIRONMENT}-elearning-vpc-private-subnet-2"
  }
}

# internet gateway
resource "aws_internet_gateway" "elearning_igw" {
  vpc_id = aws_vpc.elearning_vpc.id

  tags = {
    Name = "${var.ENVIRONMENT}-elearning-vpc-internet-gateway"
  }
}

# ELastic IP for NAT Gateway
resource "aws_eip" "elearning_nat_eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.elearning_igw]
}

# NAT gateway for private ip address
resource "aws_nat_gateway" "elearning_ngw" {
  allocation_id = aws_eip.elearning_nat_eip.id
  subnet_id     = aws_subnet.elearning_vpc_public_subnet_1.id
  depends_on = [aws_internet_gateway.elearning_igw]
  tags = {
    Name = "${var.ENVIRONMENT}-elearning-vpc-NAT-gateway"
  }
}

# Route Table for public Architecture
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.elearning_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.elearning_igw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-elearning-public-route-table"
  }
}

# Route table for Private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.elearning_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.elearning_ngw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-elearning-private-route-table"
  }
}

# Route Table association with public subnets
resource "aws_route_table_association" "to_public_subnet1" {
  subnet_id      = aws_subnet.elearning_vpc_public_subnet_1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "to_public_subnet2" {
  subnet_id      = aws_subnet.elearning_vpc_public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# Route table association with private subnets
resource "aws_route_table_association" "to_private_subnet1" {
  subnet_id      = aws_subnet.elearning_vpc_private_subnet_1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "to_private_subnet2" {
  subnet_id      = aws_subnet.elearning_vpc_private_subnet_2.id
  route_table_id = aws_route_table.private.id
}



#Output Specific to Custom VPC
output "my_vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.elearning_vpc.id
}

output "private_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.elearning_vpc_private_subnet_1.id
}

output "private_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.elearning_vpc_private_subnet_2.id
}

output "public_subnet1_id" {
  description = "Subnet ID"
  value       = aws_subnet.elearning_vpc_public_subnet_1.id
}

output "public_subnet2_id" {
  description = "Subnet ID"
  value       = aws_subnet.elearning_vpc_private_subnet_2.id
}