resource "aws_security_group" "back" {
  vpc_id = var.vpc_id

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.private_ips["front"]}/32"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.private_ips["front"]}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.anywhere_ip]
  }

  tags = {
    Name = "BODA backend security group"
  }
}

resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_keys["back"]
  subnet_id     = var.private_subnet_ids[var.instance_indexes["back"] - 1]
  vpc_security_group_ids = [aws_security_group.back.id]
  private_ip = var.private_ips["back"]
  
  tags = {
    Name = "BODA Backend"
  }
}