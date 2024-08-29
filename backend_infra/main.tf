# VPC 모듈 가져오기
module "vpc" {
  source = "../modules/vpc"

  aws_region            = "ap-northeast-2"

  vpc_cidr              = "10.0.0.0/16"
  vpc_name              = "BODA-vpc"

  public_subnets_cidr   = ["10.0.16.0/20", "10.0.32.0/20"]
  private_subnets_cidr  = ["10.0.48.0/20", "10.0.64.0/20"]
  availability_zones    = ["ap-northeast-2a", "ap-northeast-2c"]
}


####################
###  Security Group
####################


resource "aws_security_group" "backend_sg" {
    name                = "backend_sg"
    description         = "Allow necessary traffic for backend server"
    vpc_id              = module.vpc.vpc_id


    # MySQL 접근 허용 (포트 3306)
    ingress {
        description     = "Allow MySQL traffic"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        cidr_blocks      = [module.vpc.vpc_cidr_block]
    }

    # SSH 접근 허용 (포트 22)
    ingress {
        description     = "Allow SSH"
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]    # 어디서든 SSH 접근 허용
    }


    # HTTPS 접근 허용 (포트 443)
    ingress {
        description     = "Allow HTTPS"
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]    # 어디서든 HTTPS 접근 허용
    }


    # 모든 아웃바운드 트래픽 허용
    egress {
        description     = "Allow all outbound traffic"
        from_port       = 0
        to_port         = 0
        protocol        = -1
        cidr_blocks      = ["0.0.0.0/0"]    # 어디서든 HTTPS 접근 허용
    }

    tags = {
        Name            = "backend-sg"
    }


}




###########################
### EC2 Instance (백엔드 서버)
###########################

resource "aws_instance" "backend" {
  ami                   = var.backend_ami  # 백엔드 서버에 사용할 AMI ID를 변수로 정의
  instance_type         = var.backend_instance_type # 인스턴스 타입을 변수로 정의
  subnet_id             = module.vpc.private_subnet_ids[0] # 프라이빗 서브넷 중 하나 선택
  security_groups       = [aws_security_group.backend_sg.name]

  tags = {
    Name                = "backend-server"
  }
}