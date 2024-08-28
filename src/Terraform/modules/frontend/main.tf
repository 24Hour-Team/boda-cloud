resource "aws_eip_association" "front" {
  instance_id = aws_instance.frontend.id
  allocation_id = data.aws_eip.front.id
}

resource "aws_security_group" "front" {
  vpc_id = var.vpc_id

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.anywhere_ip]
  }

  ingress {
    description = "react app dev localhost"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [var.anywhere_ip]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [var.anywhere_ip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.anywhere_ip]
  }

  tags = {
    Name = "BODA frontend security group"
  }
}


resource "aws_instance" "frontend" {
  ami           = var.ami_ids["Amazon Linux 2023"]
  instance_type = var.instance_type
  key_name      = var.ssh_keys["front"]
  subnet_id     = var.public_subnet_ids[var.instance_indexes["front"]]
  vpc_security_group_ids = [aws_security_group.front.id]
  private_ip = var.private_ips["front"]

  tags = {
    Name = "BODA Frontend"
  }
}