module "ami" {
  source = "./modules/AMI"
}

module "boda-network" {
  source = "./modules/network"
  
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  elastic_ips = var.elastic_ips
  anywhere_ip = var.anywhere_ip
  instance_indexes = var.instance_indexes
  instance_names = var.instance_names
  instance_type = var.instance_type
}

module "boda-bastion" {
  source = "./modules/bastion"
  
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

  ec2-s3_iam_instance_profile_name = var.ec2-s3_iam_instance_profile_name
}

module "boda-ai" {
  source = "./modules/ai"
  
  ec2-s3_iam_instance_profile_name = var.ec2-s3_iam_instance_profile_name

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
  db_subnet_cidrs = var.db_subnet_cidrs
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

module "boda-load_balancer" {
  source = "./modules/alb"

  vpc_id = module.boda-network.vpc_id
  subnet_ids = module.boda-network.public_subnet_ids
  domain_name = var.domain_name
  anywhere_ip = var.anywhere_ip
  backend_id = module.boda-back.instance_id

  depends_on = [ module.boda-network ]
}

module "boda-api_gateway" {
  source = "./modules/http_api"

  api_name = var.api_name
  api_routes = var.api_routes
  subnet_id = module.boda-network.private_subnet_ids[0]
  security_group_id = module.boda-load_balancer.load_balancer_security_group_id
  backend_arn = module.boda-load_balancer.load_balancer_listener_arn

  depends_on = [ module.boda-load_balancer ]
}

# module "boda-api_gateway" {
#   source ="./modules/api_gateway"

#   rest_api_name = "boda-api"
#   stage_name = "prod"
#   vpc_link_id = module.boda-vpc_link.vpc_link_id
# }

# module "boda-load_balancer" {
#   source = "./modules/load_balancer"

#   vpc_id = module.boda-network.vpc_id
#   subnet_ids = module.boda-network.public_subnet_ids

#   # route53_zone_id = var.route53_zone_id
#   domain_name = var.domain_name
#   # target_group_arn = var.target_group_arn
  
# }

# module "boda-vpc_link" {
#   source = "./modules/vpc_link"

#   load_balancer_arn = module.boda-load_balancer.boda_load_balancer_arn
  
# }