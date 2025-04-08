provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-084568db4383264d4"
  instance_type          = "t2.micro"
  key_name               = "jenkins-key"
  vpc_security_group_ids = [aws_security_group.jenkins-security.id]
  availability_zone      = "us-east-1a"

  # user data
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu

    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker --version
    docker-compose --version
  EOF

  tags = {
    Name = "jenkins"
  }
}

data "aws_security_group" "sonar-security" {
  filter {
    name   = "group-name"
    values = ["sonar-security"]
  }
}

resource "aws_security_group" "jenkins-security" {
  name        = "jenkins-security"
  description = "Modified security group rules"

  tags = {
    Name = "jenkins-security"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.jenkins-security.id
  cidr_ipv4         = "103.98.209.218/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "my-login" {
  security_group_id = aws_security_group.jenkins-security.id
  cidr_ipv4         = "103.98.209.218/32"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_ingress_rule" "sonar-login" {
  security_group_id            = aws_security_group.jenkins-security.id
  referenced_security_group_id = data.aws_security_group.sonar-security.id # Replace with the other security group ID
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jenkins-security.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.jenkins-security.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_key_pair" "jenkins-key" {
  key_name   = "jenkins-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJImjmRcBB/Y92UjHLXyRARB+91U4Ti1BYZBlQwg3PH7 augus@DESKTOP-HTAUD35"
}
