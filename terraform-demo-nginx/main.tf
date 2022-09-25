
resource "aws_key_pair" "my_key" {
  key_name   = "my_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

data "aws_ami" "latest-ubuntu" {
  most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

resource "aws_instance" "MyFirstInstnace" {
  ami           = data.aws_ami.latest-ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name
  availability_zone = "ap-southeast-1a"

  vpc_security_group_ids = [aws_security_group.allow-levelup-ssh.id, aws_security_group.allow-nginx.id ]
  subnet_id = aws_subnet.my_vpc-public-1.id
  user_data              = file("ec2-userdata.bash")
  tags = {
    Name = "custom_instance"
  }

  provisioner "file" {
    source      = "installNginx.sh"
    destination = "/tmp/installNginx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installNginx.sh",
      "sudo sed -i -e 's/\r$//' /tmp/installNginx.sh", # Remove the spurious CR characters.
      "sudo /tmp/installNginx.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}

resource "aws_ebs_volume" "web_volume" {
  availability_zone = "ap-southeast-1a"
  type = "gp2"
  size = 1
  tags = {
    "Name" = "web_volume"
  }
}

resource "aws_volume_attachment" "web_volume_att" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.web_volume.id
  instance_id = aws_instance.MyFirstInstnace.id
}

output "public_ip" {
  value = aws_instance.MyFirstInstnace.public_ip 
}