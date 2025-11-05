resource "aws_instance" "dev" {
    ami = "ami-01760eea5c574eb86"
    instance_type = "t3.micro"
    tags = {
      Name = "cloud"
    }

    #lifecycle {
    # create_before_destroy = true
    #}
    # lifecycle {
    #   ignore_changes = [tags,  ]
    # }
    # lifecycle {
    #   prevent_destroy = true
    # }
  
}