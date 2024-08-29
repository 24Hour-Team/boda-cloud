###################
### Security Group
###################

resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  vpc_id      = var.vpc_id

  # HTTP 접근 허용 (포트 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 어디서든 HTTP 접근 허용
  }

  # HTTPS 접근 허용 (포트 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 어디서든 HTTPS 접근 허용
  }

  # SSH 접근 허용 (포트 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 어디서든 SSH 접근 허용 (보안상 특정 IP로 제한 권장)
  }

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-sg"
  }
}





##############
### Instance
##############



resource "aws_instance" "frontend" {
  ami           = var.frontend_ami_id
  instance_type = var.frontend_instance_type
  subnet_id     = var.public_subnet_ids[0]  # 퍼블릭 서브넷 사용
  security_groups = [aws_security_group.frontend_sg.id]

  tags = {
    Name = "frontend-server"
  }
}
