output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.network.private_subnet_ids
}

output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.front.instance_public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.network.security_group_id
}