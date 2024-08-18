data "aws_eip" "front" {
    public_ip = var.elastic_ips["front"]
}