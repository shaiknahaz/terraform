provider "aws" {
  region = "ap-south-1"
}

# -----------------------------------------
# KEY PAIR
# -----------------------------------------
resource "aws_key_pair" "example" {
  key_name   = "task"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# -----------------------------------------
# VPC
# -----------------------------------------
resource "aws_vpc" "myvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# -----------------------------------------
# SUBNET
# -----------------------------------------
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

# -----------------------------------------
# INTERNET GATEWAY
# -----------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# -----------------------------------------
# ROUTE TABLE
# -----------------------------------------
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# -----------------------------------------
# ROUTE TABLE ASSOCIATION
# -----------------------------------------
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

# -----------------------------------------
# SECURITY GROUP
# -----------------------------------------
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -----------------------------------------
# EC2 INSTANCE (UBUNTU)
# -----------------------------------------
resource "aws_instance" "server" {
  ami                         = "ami-00af95fa354fdb788"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.example.key_name
  subnet_id                   = aws_subnet.sub1.id
  vpc_security_group_ids      = [aws_security_group.webSg.id]
  associate_public_ip_address = true

  tags = {
    Name = "UbuntuServer"
  }
}

# -----------------------------------------
# NULL RESOURCE WITH REMOTE-EXEC
# -----------------------------------------
resource "null_resource" "run_script" {

  depends_on = [aws_instance.server]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.server.public_ip
    private_key = ("~/.ssh/id_ed25519")
  }
}

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update -y",
#       "sudo apt install nginx -y",
#       "echo 'hello from awsdevopsmulticloud-by-veera-nareshit-devops' >> /home/ubuntu/file200"
#     ]
#   }
# }
