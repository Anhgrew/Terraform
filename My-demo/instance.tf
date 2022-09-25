resource "aws_instance" "My-demo" {
  count         = 2
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  tags = {
    Name = "demo_instance-${count.index}"
  }
  # security_groups = var.Security_Groups

  key_name        = aws_key_pair.my-key.key_name

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

resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
