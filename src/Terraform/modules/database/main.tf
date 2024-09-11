resource "aws_security_group" "db" {
  vpc_id = var.vpc_id

  ingress {
    description = "MySQL"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.private_ips["back"]}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.anywhere_ip]
  }

  tags = {
    Name = "BODA database security group"
  }
}


resource "aws_db_instance" "database" {
    identifier            = var.identifier
    engine                = var.engine
    engine_version        = var.engine_version
    instance_class        = var.instance_class
    allocated_storage     = var.allocated_storage
    storage_type          = var.storage_type

    db_name               = var.db_name
    username              = var.db_username
    password              = var.db_password
    
    publicly_accessible   = false
    skip_final_snapshot   = true
    vpc_security_group_ids = [aws_security_group.db.id]
    db_subnet_group_name     = var.database_subnet_group_name
    tags = {
        Name = "${var.identifier}"
    }
}