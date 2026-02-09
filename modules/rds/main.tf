resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnets
}

resource "aws_db_instance" "db" {
  identifier             = "${var.project_name}-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [var.db_sg]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false

  username = "adminuser"
  password = "Password123!"
}
