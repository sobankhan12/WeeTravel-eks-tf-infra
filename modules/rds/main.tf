resource "aws_db_subnet_group" "db-subnet" {
name = "wetravel-db-subnet-group"
subnet_ids = var.subnet_ids

}

resource "aws_security_group" "allow_rds" {
  name        = "wetravelrds"
  description = "wetravelrds"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  identifier           = "tf-rds-wetravel"
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.28"
  instance_class       = "db.t2.micro"
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password
  multi_az             = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name
  publicly_accessible  = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [ aws_security_group.allow_rds.id ]
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 1

  tags = {
    Name = "WeTravel_Task-db"
  }
}

resource "aws_db_instance" "read_replica" {
  allocated_storage           = 20
  identifier                  = "tf-read-replica-wetravel"
  replicate_source_db         = aws_db_instance.rds_instance.identifier
  instance_class              = "db.t2.micro"
  # multi_az             = true
  db_subnet_group_name        = aws_db_subnet_group.db-subnet.name
  publicly_accessible         = true
  skip_final_snapshot         = true
  vpc_security_group_ids      = [ aws_security_group.allow_rds.id ]

  tags = {
    Name = "WeTravel_Task-db"
  }
}