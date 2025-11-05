resource "aws_instance" "name" {
  ami = "ami-00af95fa354fdb788"
  instance_type = "t3.micro"
  tags = {
    Name = "myin"
  }

}

#example command terraform import aws_instance.name i-0f805ae729b101f2f