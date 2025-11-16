variable "env" {
    type = list(string)
    default = [ "dev","test","prod"]
  
}

resource "aws_instance" "name" {
    ami = "ami-03695d52f0d883f65"
    instance_type = "t3.micro"
    for_each = toset(var.env) 
    # tags = {
    #   Name = "dev"
    # }
  tags = {
      Name = each.value
    }
}