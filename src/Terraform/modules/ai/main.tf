resource "aws_iam_instance_profile" "boda_ec2-s3_instance_profile" {
  name = var.ec2-s3_iam_instance_profile_name
  role = var.ec2-s3_role_name
}

resource "aws_instance" "ai" {
  ami           = var.ami_ids["Amazon Linux 2023"]
  instance_type = var.instance_type
  key_name      = var.ssh_keys["ai"]
  subnet_id     = var.private_subnet_ids[var.instance_indexes["ai"] - 1]
  vpc_security_group_ids = [var.private_security_group_id]

  iam_instance_profile = var.ec2-s3_iam_instance_profile_name
  
  tags = {
    Name = "BODA AI"
  }
}