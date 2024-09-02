# terraform.tfvars

# VPC
aws_region = "ap-northeast-2"
vpc_cidr = "10.0.0.0/16"
vpc_name = "BODA-vpc"

public_subnets_cidr = ["10.0.16.0/20", "10.0.32.0/20"]
private_subnets_cidr = ["10.0.48.0/20", "10.0.64.0/20"]
availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]

frontend_elastic_ip = "13.125.77.174"
nat_elastic_ip = "3.37.24.94"


#Load Balancer

domain_name         = "yourdomain.com"
route53_zone_id     = "Z1234567890EXAMPLE"
target_group_arn    = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/6d0ecf831eec9f09"



# FrontEND

frontend_ami_id        = "ami-FrontEnd"
frontend_instance_type = "t2.micro"
frontend_key_name      = "my-frontend-key"


# BackEND
backend_ami            = "ami-BACK"
backend_instance_type  = "t2.micro"
backend_private_ip     = "10.0.48.10"



# RDS(DB)
db_allocated_storage   = 20
db_engine              = "mysql"
db_engine_version      = "8.0.39"
db_instance_class      = "db.t2.micro"
db_name                = "BODA-db"
db_username            = "admin"
db_password            = "supersecurepassword"


# AI Infrastructure
ai_ami_id             = "ami-AI"
ai_instance_type      = "t3.medium"
ai_key_name           = "my-ai-key"
