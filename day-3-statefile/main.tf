resource "aws_instance" "name" { 
    instance_type = "t3.micro"
    region = "ap-southeast-2"
     ami = var.ami_id
     tags = {
       Name = "sana"
     }

}

resource "aws_s3_bucket" "name" {
    bucket = "sulthanpuuuriiii"
  
}


