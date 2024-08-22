module "boda-network" {
  source = "./modules/network"
  
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  elastic_ips = var.elastic_ips
  instance_indexes = var.instance_indexes
  instance_names = var.instance_names
  instance_type = var.instance_type
}

module "boda-front" {
  source = "./modules/frontend"
  
  vpc_id = module.boda-network.vpc_id
  public_subnet_ids = module.boda-network.public_subnet_ids
  security_group_id = module.boda-network.security_group_id
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
  security_group_id = module.boda-network.security_group_id
  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
}

module "boda-db" {
  source = "./modules/database"
  
  vpc_id = module.boda-network.vpc_id
  private_subnet_ids = module.boda-network.private_subnet_ids
  security_group_id = module.boda-network.security_group_id
  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
}

module "boda-ai" {
  source = "./modules/ai"
  
  vpc_id = module.boda-network.vpc_id
  private_subnet_ids = module.boda-network.private_subnet_ids
  security_group_id = module.boda-network.security_group_id
  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
}