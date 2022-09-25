#Security Group for my_vpc
resource "aws_security_group" "allow-levelup-ssh" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "allow-levelup-ssh"
  description = "security group that allows ssh connection"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow-levelup-ssh"
  }
}

#Security Group for MariaDB
resource "aws_security_group" "allow-nginx" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "allow-nginx"
  description = "security group for Maria DB"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "allow-nginx"
  }
}