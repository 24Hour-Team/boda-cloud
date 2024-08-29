# 루트 디렉토리에서 각 모듈 호출(생성)


# FrontEnd Infrastructure Module

module "frontend_infra" {
  source = "./frontend_infra"

  frontend_ami_id = var.frontend_ami_id
  frontend_instance_type = var.frontend_instance_type
  frontend_key_name = var.frontend_key_name
  
}


# BackEnd Infrastructure Module

module "backend_infra" {
  source = "./backend_infra"

  backend_ami = var.backend_ami
  backend_instance_type = var.backend_instance_type
  backend_private_ip = var.backend_private_ip

}


# AI Infrastructure Module

module "ai_infra" {
  source = "./AI_infra"

  ai_ami_id             = var.ai_ami_id
  ai_instance_type      = var.ai_instance_type
  ai_key_name           = var.ai_key_name
  
}

# DB Infrastructure Module

module "db_infra" {
  source = "./db_infra"

  db_allocated_storage  = var.db_allocated_storage
  db_engine             = var.db_engine
  db_engine_version     = var.db_engine_version
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
}