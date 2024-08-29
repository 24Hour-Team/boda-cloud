output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}


output "backend_instance_id" {
  description = "The ID of the backend EC2 instance"
  value       = aws_instance.backend.id
}

output "backend_security_group_id" {
  description = "The ID of the security group for the backend server"
  value       = aws_security_group.backend_sg.id
}
