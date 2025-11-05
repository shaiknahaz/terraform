
resource "aws_instance" "name" {
    ami = "ami-00af95fa354fdb788"
    instance_type = "t3.micro"
    availability_zone = "ap-south-1a"
    tags = {
        Name = "cloud"
    }

}

resource "aws_s3_bucket" "name" {
    bucket = "hvdudvwgdvwugdcubbwdssfgdhfgdfjdjy"
  

}


#teragte resource we can user to apply specific resource level only belwo command is the reference 
#terraform apply -target=aws_s3_bucket.name

#try skip resource 