provider "aws" {
  region = "ap-south-1"   # ✅ Set your AWS region (Mumbai). Change if needed.
}

# ✅ Data source to fetch subnet details by Name tag
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["cloud"]  # Ensure your subnet in AWS console has Name = cloud
  }
}

# ✅ Data source to fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ✅ EC2 instance using the selected subnet and latest AMI
resource "aws_instance" "example" {
  ami           = data.aws_ami.amzlinux.id
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.selected.id

  tags = {
    Name = "cloud-instance"
  }
}
