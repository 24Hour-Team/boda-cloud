output "frontend_instance_id" {
  description = "The ID of the frontend EC2 instance"
  value       = aws_instance.frontend.id
}

output "frontend_instance_public_ip" {
  description = "The public IP of the frontend EC2 instance"
  value       = aws_instance.frontend.public_ip
}

output "frontend_security_group_id" {
  description = "The ID of the frontend security group"
  value       = aws_security_group.frontend_sg.id
}
