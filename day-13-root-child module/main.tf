module "vpc" {
  source        = "./modules/vpc"
  cidr_block    = "10.0.0.0/16"
  subnet_1_cidr = "10.0.1.0/24"
  subnet_2_cidr = "10.0.2.0/24"
  az1           = "ap-south-1a"
  az2           = "ap-south-1b"
}

module "ec2" {
  source        = "./modules/ec2"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_1_id
  sg_id         = module.vpc.sg_id
}

module "rds" {
  source = "./modules/rds"

  db_name        = var.db_name
  db_user        = var.db_user
  db_password    = var.db_password
  instance_class = var.instance_class

  subnet_1_id = module.vpc.subnet_1_id
  subnet_2_id = module.vpc.subnet_2_id
}

module "s3" {
  source = "./modules/s3"

  bucket = var.bucket
  tags   = var.tags
}
