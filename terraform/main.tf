resource "aws_iam_role" "ec2-role-terraform" {
  name = "ec2-role-terraform"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-role-terraform-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = aws_iam_role.ec2-role-terraform.name
}

resource "aws_iam_instance_profile" "ec2-role-terraform-instance-profile" {
  name = "example-instance-profile"
  role = aws_iam_role.ec2-role-terraform.name
}

resource "aws_security_group" "sg-vpn-terraform" {
  name_prefix = "example-sg"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vpn" {
  count         = var.vpn_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "vpn-test"
  associate_public_ip_address = "true"
#  iam_instance_profile = "ec2-test-role"
  iam_instance_profile = aws_iam_instance_profile.ec2-role-terraform-instance-profile.name
  vpc_security_group_ids = [aws_security_group.sg-vpn-terraform.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update && apt-get install awscli -y
              curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
              chmod +x openvpn-install.sh
              sed -i "s/10\.8\.0\.0/10.${count.index + 1}.0.0/g" openvpn-install.sh
              AUTO_INSTALL=y ./openvpn-install.sh
              cd /root && mv client.ovpn client_${count.index + 1}.ovpn
              sed -i "s/dev tun/dev tun${count.index + 1}/g" client_${count.index + 1}.ovpn
              aws s3 cp /root/client_${count.index + 1}.ovpn s3://vpn-config-terraform
              EOF

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = "8"
  }

  tags = {
    Name = format("vpn_terraform_%d", count.index + 1)
  }

  depends_on = [
    aws_s3_bucket.vpn_bucket
  ]

}

resource "aws_instance" "target" {
  count         = var.target_count
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name      = "vpn-test"
  associate_public_ip_address = "true"

  user_data = <<-EOF
              #!/bin/bash
              apt-get install -y ca-certificates curl gnupg lsb-release
              mkdir -m 0755 -p /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              apt-get update
              apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
              systemctl start docker
              docker run --name nginx_latest -p 80:80 -itd nginx:latest
              docker run --name nginx_cve -p 81:80 -itd nginx:1.20.0
              nc -lkd 1000 >/dev/null &
              nc -lkd 2000 >/dev/null &
              nc -lkd 3000 >/dev/null &
              nc -lkd 4000 >/dev/null &
              nc -lkd 5000 >/dev/null &
              nc -lkd 6000 >/dev/null &
              nc -lkd 7000 >/dev/null &
              nc -lkd 8000 >/dev/null &
              nc -lkd 8080 >/dev/null &
              nc -lkd 9999 >/dev/null &
              EOF

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = "8"
  }

  tags = {
    Name = format("target_terraform_%d", count.index + 1)
  }
}

resource "aws_s3_bucket" "vpn_bucket" {
  bucket = "vpn-config-terraform"
  force_destroy = true
}

resource "aws_instance" "entrypoint_server" {
  count         = var.entrypoint_server_count
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t3.medium"
  key_name      = "vpn-test"
  associate_public_ip_address = "true"
  iam_instance_profile = "ec2-test-role"

  user_data = <<-EOF
              #!/bin/bash
              apt-get update && apt-get install awscli openvpn -y
              mkdir -p /tmp/ovpn_client_config/
              cd /tmp/ovpn_client_config/
              sleep 30
              aws s3 cp --recursive s3://vpn-config-terraform ./
              for i in $(ls -1v); do sudo openvpn --config $i --daemon; done
              EOF

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = "8"
  }

  tags = {
    Name = format("entrypoint_server_terraform_%d", count.index + 1)
  }

  depends_on = [
    aws_s3_bucket.vpn_bucket,
    aws_instance.vpn
  ]

}

resource "aws_ecr_repository" "docker_backend" {
  name                 = "willow_backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "docker_frontend" {
  name                 = "willow_frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_repository" "docker_saver" {
  name                 = "willow_saver"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
