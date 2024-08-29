output "db_instance_id" {
  description = "The ID of the MySQL DB instance"
  value       = aws_db_instance.db.id
}

output "db_instance_endpoint" {
  description = "The endpoint of the MySQL DB instance"
  value       = aws_db_instance.db.endpoint
}

output "db_security_group_id" {
  description = "The ID of the security group associated with the MySQL DB instance"
  value       = aws_security_group.db_sg.id
}
