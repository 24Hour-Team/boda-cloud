output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.main.id
}

output "database_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = aws_db_subnet_group.db.name
}