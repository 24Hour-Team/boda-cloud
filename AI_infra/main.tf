####################
### Security Group
####################

resource "aws_security_group" "ai_sg" {
  name          = "ai_sg"
  vpc_id        = var.vpc_id

  # HTTP 포트 허용
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]  # VPC 내부에서만 접근 허용
  }

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ai-sg"
  }
}

##############
### Instance
##############

resource "aws_instance" "ai" {
  ami           = var.ai_ami_id
  instance_type = var.ai_instance_type
  subnet_id     = var.private_subnet_ids[0]  # 프라이빗 서브넷 사용
  security_groups = [aws_security_group.ai_sg.id]

  tags = {
    Name = "ai-server"
  }
}
