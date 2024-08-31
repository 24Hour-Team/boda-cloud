module "ami" {
  source = "./modules/AMI"
}

module "boda-network" {
  source = "./modules/network"
  
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs = var.db_subnet_cidrs
  elastic_ips = var.elastic_ips
  anywhere_ip = var.anywhere_ip
  instance_indexes = var.instance_indexes
  instance_names = var.instance_names
  instance_type = var.instance_type
}

module "boda-front" {
  source = "./modules/frontend"
  
  vpc_id = module.boda-network.vpc_id
  public_subnet_ids = module.boda-network.public_subnet_ids

  instance_type = var.instance_type
  ami_id = module.ami.amazon_linux_id
  ssh_keys = var.ssh_keys
  elastic_ips = var.elastic_ips
  private_ips = var.private_ips
  anywhere_ip = var.anywhere_ip
  instance_indexes = var.instance_indexes
  instance_names = var.instance_names
}

module "boda-back" {
  source = "./modules/backend"
  
  vpc_id = module.boda-network.vpc_id
  private_subnet_ids = module.boda-network.private_subnet_ids
  elastic_ips = var.elastic_ips
  private_ips = var.private_ips
  anywhere_ip = var.anywhere_ip

  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_id = module.ami.amazon_linux_id
  ssh_keys = var.ssh_keys
}

module "boda-ai" {
  source = "./modules/ai"
  
  ec2-s3_iam_instance_profile_name = var.ec2-s3_iam_instance_profile_name
  ec2-s3_role_name = var.ec2-s3_role_name
  
  vpc_id = module.boda-network.vpc_id
  private_subnet_ids = module.boda-network.private_subnet_ids
  private_ips = var.private_ips
  anywhere_ip = var.anywhere_ip
  
  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_id = module.ami.amazon_linux_id
  ssh_keys = var.ssh_keys
}

module "boda-db" {
  source = "./modules/database"
  
  vpc_id = module.boda-network.vpc_id
  database_subnet_group_name = module.boda-network.database_subnet_group_name
  private_ips = var.private_ips
  anywhere_ip = var.anywhere_ip

  identifier = var.identifier
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}