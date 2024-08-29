output "ai_instance_id" {
  description = "The ID of the AI EC2 instance"
  value       = aws_instance.ai.id
}

output "ai_instance_private_ip" {
  description = "The private IP of the AI EC2 instance"
  value       = aws_instance.ai.private_ip
}

output "ai_security_group_id" {
  description = "The ID of the security group associated with the AI EC2 instance"
  value       = aws_security_group.ai_sg.id
}
