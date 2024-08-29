####################
### Security Group
####################

resource "aws_security_group" "db_sg" {
  name          = "db_sg"
  vpc_id        = var.vpc_id

  # 데이터베이스 포트 허용 (MySQL 예시: 3306)
  ingress {
    description     = "Allow MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # cidr_blocks = ["10.0.0.0/16"]  # VPC 내부에서만 접근 허용
    cidr_blocks = [var.vpc_cidr] #VPC 내부에서만 접근 허용
  }

  

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}


####################
### DB Subnet Group
####################

# 여러 서브넷을 포함하는 서브넷 그룹을 정의
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "boda single db subnet group"
  subnet_ids = [
    var.private_subnet_ids[0]
  ]

  tags = {
    Name = "Single DB subnet group"
  }
}





#################
### DB instance
#################

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name  # 프라이빗 서브넷 사용
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  tags = {
    Name = "db-server"
  }
}
