module "boda-iam-role" {
  source                = "./modules/IAM"

  role_name             = var.role_name
  iam_instance_profile_name = var.iam_instance_profile_name
  s3_bucket_arns        = var.s3_bucket_arns
}

module "boda-network" {
  source = "./modules/network"
  
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs = var.db_subnet_cidrs
  elastic_ips = var.elastic_ips
  instance_indexes = var.instance_indexes
  instance_names = var.instance_names
  instance_type = var.instance_type
}

module "boda-front" {
  source = "./modules/frontend"
  
  vpc_id = module.boda-network.vpc_id
  public_subnet_ids = module.boda-network.public_subnet_ids
  public_security_group_id = module.boda-network.public_security_group_id

  instance_type = var.instance_type
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
  elastic_ips = var.elastic_ips
  instance_indexes = var.instance_indexes
  instance_names = var.instance_names
}

module "boda-back" {
  source = "./modules/backend"
  
  vpc_id = module.boda-network.vpc_id
  private_subnet_ids = module.boda-network.private_subnet_ids
  private_security_group_id = module.boda-network.private_security_group_id

  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
}

module "boda-ai" {
  source = "./modules/ai"
  
  iam_instance_profile_name = var.iam_instance_profile_name
  
  vpc_id = module.boda-network.vpc_id
  private_subnet_ids = module.boda-network.private_subnet_ids
  private_security_group_id = module.boda-network.private_security_group_id
  
  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
}

module "boda-db" {
  source = "./modules/database"
  
  private_security_group_id = module.boda-network.private_security_group_id
  database_subnet_group_name = module.boda-network.database_subnet_group_name

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