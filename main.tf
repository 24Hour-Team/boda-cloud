# VPC 생성
module "vpc" {
  source = "./modules/vpc"
 
  aws_region            = var.aws_region
  vpc_cidr              = var.vpc_cidr
  vpc_name              = var.vpc_name

  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  availability_zones    = var.availability_zones

  frontend_elastic_ip   = var.frontend_elastic_ip
  nat_elastic_ip        = var.nat_elastic_ip
}





# 루트 디렉토리에서 각 모듈 호출(전달 모듈)-> 여기서 값을 전달받아 서브 디렉토리에서 리소스 프로비저닝
# FrontEnd Infrastructure Module

module "frontend_infra" {
  source = "./frontend_infra"
  
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  vpc_cidr               = var.vpc_cidr

  frontend_ami_id        = var.frontend_ami_id
  frontend_instance_type = var.frontend_instance_type
  frontend_key_name      = var.frontend_key_name

  
  
}


# BackEnd Infrastructure Module

module "backend_infra" {
  source = "./backend_infra"

  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_cidr               = var.vpc_cidr

  backend_ami            = var.backend_ami
  backend_instance_type  = var.backend_instance_type
  backend_private_ip     = var.backend_private_ip

  
}


# AI Infrastructure Module

module "ai_infra" {
  source = "./AI_infra"

  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_cidr               = var.vpc_cidr

  ai_ami_id              = var.ai_ami_id
  ai_instance_type       = var.ai_instance_type
  ai_key_name            = var.ai_key_name
  
  
}

# DB Infrastructure Module

module "db_infra" {
  source = "./db_infra"

  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_cidr               = var.vpc_cidr


  db_allocated_storage   = var.db_allocated_storage
  db_engine              = var.db_engine
  db_engine_version      = var.db_engine_version
  db_instance_class      = var.db_instance_class
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
}


module "api_gateway" {
  source = "./modules/api_gateway"

  rest_api_name = "boda-api"
  stage_name    = "prod"
  vpc_link_id   = module.vpc_link.vpc_link_id
}

module "vpc_link" {
  source = "./modules/vpc_link"
  
  load_balancer_arn = aws_lb.example_load_balancer.arn
}
