# resource "aws_iam_instance_profile" "boda_ec2-s3_instance_profile" {
#   name = var.ec2-s3_iam_instance_profile_name
#   role = var.ec2-s3_role_name
# }

resource "aws_security_group" "ai" {
  vpc_id = var.vpc_id

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.private_ips["back"]}/32"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.private_ips["back"]}/32"]
  }

  ingress {
    description = "Flask"
    from_port = 5000 
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["${var.private_ips["back"]}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.anywhere_ip]
  }

  tags = {
    Name = "BODA ai security group"
  }
}

resource "aws_instance" "ai" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ssh_keys["ai"]
  subnet_id     = var.private_subnet_ids[var.instance_indexes["ai"] - 1]
  vpc_security_group_ids = [aws_security_group.ai.id]
  private_ip = var.private_ips["ai"]
  iam_instance_profile = var.ec2-s3_iam_instance_profile_name
  
  tags = {
    Name = "BODA AI"
  }
}