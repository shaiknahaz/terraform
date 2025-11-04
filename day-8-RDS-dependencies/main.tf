resource "aws_instance" "name" { 
    instance_type = var.type
     ami = var.ami_id
     tags = {
       Name = "nahaz"
     }
     
  
}

resource "aws_s3_bucket" "name" {
    bucket = "jkdklbbchbubfuboubhbnahaz"
    
  
}