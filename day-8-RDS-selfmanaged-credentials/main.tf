# ---------------------------------------------------------
# Provider Configuration
# ---------------------------------------------------------
# ---------------------------------------------------------
# Data Sources - Get existing subnets by tags
# ---------------------------------------------------------
data "aws_subnet" "subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["sub-1"]
  }
}

data "aws_subnet" "subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["sub-2"]
  }
}

# ---------------------------------------------------------
# Subnet Group for RDS
# ---------------------------------------------------------
resource "aws_db_subnet_group" "sub-grp" {
  name       = "mycutsub"
  subnet_ids = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

# ---------------------------------------------------------
# RDS Instance Configuration
# ---------------------------------------------------------
resource "aws_db_instance" "default" {
  allocated_storage       = 10
  db_name                 = "db"
  identifier              = "rds-test"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "Cloud123"
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.id
  parameter_group_name    = "default.mysql8.0"

  # Backup settings
  backup_retention_period = 7
  backup_window           = "02:00-03:00"

  # Monitoring settings
  monitoring_interval     = 0
  maintenance_window      = "sun:04:00-sun:05:00"

  # Ensure it can be destroyed without snapshot issues
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name = "Terraform-RDS-Instance"
  }
}

# ---------------------------------------------------------
# OUTPUT - To display RDS endpoint after creation
# ---------------------------------------------------------
output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}

# ---------------------------------------------------------
# TERRAFORM COMMANDS TO RUN (in terminal)
# ---------------------------------------------------------
# 1️⃣ Initialize project
# terraform init

# 2️⃣ Validate configuration
# terraform validate

# 3️⃣ Show what will be created
# terraform plan

# 4️⃣ Create RDS and subnet group
# terraform apply -auto-approve

# 5️⃣ (If you face 'final_snapshot_identifier' error again)
#    Run these commands manually in terminal:

#    👉 Remove old RDS resource from Terraform state
# terraform state rm aws_db_instance.default

#    👉 Delete the DB manually from AWS Console:
#       - Go to AWS RDS > Databases > rds-test
#       - Click "Delete"
#       - Check "Skip final snapshot"
#       - Confirm deletion

#    👉 Then reapply configuration
# terraform init -reconfigure
# terraform apply -auto-approve

# 6️⃣ To destroy everything safely
# terraform destroy -auto-approve
