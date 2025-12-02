resource "aws_instance" "name" { 
  instance_type = var.type     # using variable
  ami           = var.ami_id

  tags = {
    Name = "sana"
  }
}
