resource "aws_instance" "name" { 
    instance_type = var.type
     ami = var.ami_id
     tags = {
       Name = "sana"
     }

}

resource "aws_s3_bucket" "name" {
    bucket = "sulthanpuuuriiii"
  
}


