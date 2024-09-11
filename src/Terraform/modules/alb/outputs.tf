output "load_balancer_arn" {
  value = aws_lb.boda_load_balancer.arn
}

output "load_balancer_security_group_id" {
  value = aws_security_group.loda_balancer.id
}

output "load_balancer_listener_arn" {
  value = aws_lb_listener.http.arn
}