provider "aws" {
  region = "ap-south-1"
}

# --------------------------
# Primary RDS Instance
# --------------------------
resource "aws_db_instance" "primary" {
  identifier              = "my-primary-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = "admin"
  password                = "Admin12345!"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  publicly_accessible     = false
  deletion_protection     = false

  # ✅ Required for read replicas
  backup_retention_period = 1
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "Primary-DB"
  }
}

# --------------------------
# Read Replica
# --------------------------
resource "aws_db_instance" "read_replica" {
  identifier              = "my-read-replica"
  replicate_source_db     = aws_db_instance.primary.identifier   # ✅ Corrected
  instance_class          = "db.t3.micro"
  publicly_accessible     = false
  apply_immediately       = true
  skip_final_snapshot     = true

  depends_on = [aws_db_instance.primary]

  tags = {
    Name = "Read-Replica"
  }
}
