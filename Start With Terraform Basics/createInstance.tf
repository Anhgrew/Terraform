
resource "aws_instance" "My-demo" {
  count         = 2
  ami           = "ami-0dd1e66116f7975b8"
  instance_type = "t2.micro"

  tags = {
    Name = "demo_instance-${count.index}"
  }
}