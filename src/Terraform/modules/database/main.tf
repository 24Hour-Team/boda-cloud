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

    skip_final_snapshot   = true
    vpc_security_group_ids = [var.security_group_id]
    db_subnet_group_name     = var.database_subnet_group_name
    tags = {
        Name = "${var.identifier}"
    }
}