resource "aws_eip_association" "bastion" {
  instance_id = aws_instance.bastion.id
  allocation_id = data.aws_eip.bastion.id
}

resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id

  ingress {
    description = "ssh"
    from_port = 22
    to_port = 22
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
    Name = "BODA bastion security group"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_keys["bastion"]
  subnet_id     = var.public_subnet_ids[var.instance_indexes["bastion"]]
  vpc_security_group_ids = [aws_security_group.bastion.id]
  private_ip = var.private_ips["bastion"]

  tags = {
    Name = "BODA Bastion"
  }
}