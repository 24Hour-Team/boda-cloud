data "aws_eip" "bastion" {
    public_ip = var.elastic_ips["bastion"]
}