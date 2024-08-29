# VPC 정보를 참조하기 위해 terraform_remote_state 사용
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../backend_infra/terraform.tfstate"  # backend_infra에서 생성된 VPC의 상태 파일 경로
  }
}

####################
### Security Group
####################

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # 데이터베이스 포트 허용 (MySQL 예시: 3306)
  ingress {
    description     = "Allow MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # cidr_blocks = ["10.0.0.0/16"]  # VPC 내부에서만 접근 허용
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block] #VPC 내부에서만 접근 허용
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
    data.terraform_remote_state.vpc.outputs.private_subnet_ids[0]
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
  engine               = "mysql"
  engine_version       = "8.0.39"
  instance_class       = "db.t3.micro"
  db_name                 = "BODA-db"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = data.terraform_remote_state.vpc.outputs.private_subnet_ids[0]  # 프라이빗 서브넷 사용
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  tags = {
    Name = "db-server"
  }
}
