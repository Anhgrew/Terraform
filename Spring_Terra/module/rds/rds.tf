
#Call VPC Module First to get the Subnet IDs
# module "elearning-vpc" {
#     source      = "../vpc"

#     ENVIRONMENT = var.ENVIRONMENT
#     AWS_REGION  = var.AWS_REGION
# }

#Define Subnet Group for RDS Service
resource "aws_db_subnet_group" "elearning-rds-subnet-group" {

    name          = "elearning-db-snet"
    description   = "Allowed subnets for DB cluster instances"
    subnet_ids    = [
      "${var.vpc_private_subnet1}",
      "${var.vpc_private_subnet2}",
    ]
    tags = {
        Name         = "${var.ENVIRONMENT}_elearning_db_subnet"
    }
}

#Define Security Groups for RDS Instances
resource "aws_security_group" "elearning-rds-sg" {

  name = "elearning-rds-sg"
  description = "Created by Elearning"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "${var.ENVIRONMENT}-elearning-rds-sg"
   }
}

resource "aws_db_instance" "elearning-rds" {
  identifier = "elearning-rds"
  allocated_storage = var.ELEARNING_RDS_ALLOCATED_STORAGE
  storage_type = "gp2"
  engine = var.ELEARNING_RDS_ENGINE
  engine_version = var.ELEARNING_RDS_ENGINE_VERSION
  instance_class = var.DB_INSTANCE_CLASS
  backup_retention_period = var.BACKUP_RETENTION_PERIOD
  publicly_accessible = var.PUBLICLY_ACCESSIBLE
  username = var.ELEARNING_RDS_USERNAME
  password = var.ELEARNING_RDS_PASSWORD
  vpc_security_group_ids = [aws_security_group.elearning-rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.elearning-rds-subnet-group.name
  multi_az = "false"
}

output "rds_prod_endpoint" {
  value = aws_db_instance.elearning-rds.endpoint
}