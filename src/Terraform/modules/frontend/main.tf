resource "aws_eip_association" "front" {
  instance_id = aws_instance.frontend.id
  allocation_id = data.aws_eip.front.id
}

resource "aws_instance" "frontend" {
  ami           = var.ami_ids["Amazon Linux 2023"]
  instance_type = var.instance_type
  key_name      = var.ssh_keys["front"]
  subnet_id     = var.public_subnet_ids[var.instance_indexes["front"]]
  vpc_security_group_ids = [var.public_security_group_id]
  
  tags = {
    Name = "BODA Frontend"
  }
}