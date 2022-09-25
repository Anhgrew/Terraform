resource "aws_security_group" "elearning_webservers_alb" {
  tags = {
    Name = "${var.ENVIRONMENT}-elearning-webservers-ALB"
  }
  name = "${var.ENVIRONMENT}-elearning-webservers-ALB"
  description = "Created by elearning"
  vpc_id      = module.elearning-vpc.my_vpc_id 

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
