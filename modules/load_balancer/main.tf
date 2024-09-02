resource "aws_lb" "example_load_balancer" {
  name               = "example-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  # subnets            = [aws_subnet.public_subnet[*].id]
  subnets            = var.subnet_ids
  
  enable_deletion_protection = false
}

resource "aws_security_group" "lb_sg" {
  name   = "lb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Load Balancer Target Group
resource "aws_lb_target_group" "your_target_group" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  
  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}


# ACM 리소스

resource "aws_acm_certificate" "example_cert" {
  domain_name = "YOURDOMAIN.com"   #추후에 반드시 변경
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
  
}


# DNS 검증 설정

# resource "aws_route53_record" "example_cert_validation" {
#   name    = aws_acm_certificate.example_cert.domain_validation_options[0].resource_record_name
#   type    = aws_acm_certificate.example_cert.domain_validation_options[0].resource_record_type
#   zone_id = "your-route53-zone-id"
#   records = [aws_acm_certificate.example_cert.domain_validation_options[0].resource_record_value]
#   ttl     = 60
# }

resource "aws_route53_record" "example_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.example_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = var.route53_zone_id
  records = [each.value.value]
  ttl     = 60
}



# HTTPS 리스너 추가

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.example_load_balancer.arn
  port = "443"
  protocol = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.example_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.your_target_group.arn
  }
}

  
