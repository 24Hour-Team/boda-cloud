output "backend_instance_id" {
  description = "The ID of the backend EC2 instance"
  value       = aws_instance.backend.id
}

output "backend_security_group_id" {
  description = "The ID of the security group for the backend server"
  value       = aws_security_group.backend_sg.id
}
