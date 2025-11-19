provider "aws" {
  region = "ap-southeast-2"    # <-- Your region here
}

resource "aws_instance" "name" { 
  instance_type = "t3.small"   # t3.micro is Free Tier eligible
  ami           = var.ami_id

  tags = {
    Name = "sana"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "sulthanpuuuriiii"
}
