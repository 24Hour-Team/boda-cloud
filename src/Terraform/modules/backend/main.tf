resource "aws_instance" "backend" {
  ami           = var.ami_ids["Amazon Linux 2023"]
  instance_type = var.instance_type
  key_name      = var.ssh_keys["back"]
  subnet_id     = var.private_subnet_ids[var.instance_indexes["back"] - 1]
  vpc_security_group_ids = [var.private_security_group_id]

  private_ip = "10.0.3.111"
  
  tags = {
    Name = "BODA Backend"
  }
}