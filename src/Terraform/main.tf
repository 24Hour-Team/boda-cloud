module "network" {
  source = "./modules/network"
  
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  elastic_ips = var.elastic_ips
  instance_indexes = var.instance_indexes
  instance_names = var.instance_names
  instance_type = var.instance_type
}

module "front" {
  source = "./modules/frontend"
  
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  security_group_id = module.network.security_group_id
  instance_type = var.instance_type
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
  elastic_ips = var.elastic_ips
  instance_indexes = var.instance_indexes
  instance_names = var.instance_names
}

module "back" {
  source = "./modules/backend"
  
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id = module.network.security_group_id
  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
}

module "db" {
  source = "./modules/database"
  
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id = module.network.security_group_id
  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
}

module "ai" {
  source = "./modules/ai"
  
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id = module.network.security_group_id
  instance_type = var.instance_type
  instance_indexes = var.instance_indexes
  ami_ids = var.ami_ids
  ssh_keys = var.ssh_keys
}