resource "aws_lb" "boda_load_balancer" {
  name               = "boda-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loda_balancer.id]
  subnets            = var.subnet_ids
  
  enable_deletion_protection = false
}

resource "aws_security_group" "loda_balancer" {
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.anywhere_ip]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.anywhere_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere_ip]
  }

  tags = {
    Name = "BODA load balancer security group"
  }
}

# ALB 대상 그룹
resource "aws_lb_target_group" "boda_target_group_http" {
  name     = "boda-target-group-http"
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

resource "aws_lb_target_group" "boda_target_group_https" {
  name     = "boda-target-group-https"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id
  target_type = "instance"
  
  health_check {
    path                = "/"
    protocol            = "HTTPS"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

// HTTP -> HTTPS 리다이렉트
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.boda_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.boda_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.boda.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.boda_target_group_http.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = aws_lb_target_group.boda_target_group_http.arn
  target_id        = var.backend_id
  port             = 80
}