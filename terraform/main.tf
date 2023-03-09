resource "aws_instance" "vpn" {
  count         = var.vpn_count
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name      = "vpn-test"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = "8"
  }
  associate_public_ip_address = "true"

  tags = {
    Name = format("vpn_terraform_%d", count.index + 1)
  }
}

resource "aws_instance" "target" {
  count         = var.target_count
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name      = "vpn-test"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = "8"
  }
  associate_public_ip_address = "true"

  tags = {
    Name = format("target_terraform_%d", count.index + 1)
  }
}
