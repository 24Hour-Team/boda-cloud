data "aws_acm_certificate" "boda" {
    domain = var.domain_name
}