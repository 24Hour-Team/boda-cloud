# terraform.tfvars

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
