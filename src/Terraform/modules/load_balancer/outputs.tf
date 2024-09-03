output "example_load_balancer_arn" {
  value = aws_lb.example_load_balancer.arn
}



output "lb_security_group_id" {
  value = aws_security_group.lb_sg.id
}


output "route53_zone_id" {
  value = aws_route53_zone.example_route53_zone.zone_id
}
