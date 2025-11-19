resource "aws_instance" "name" { 
    instance_type = "t3.micro"
     ami = var.ami_id
     tags = {
       Name = "sana"
     }

}

resource "aws_s3_bucket" "name" {
    bucket = "sulthanpuuuriiii"
  
}


