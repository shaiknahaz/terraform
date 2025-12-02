# resource "aws_instance" "name" {
#     ami = "ami-0d176f79571d18a8f"
#     instance_type = "m7i-flex.large"
#     count = 2
#     # tags = {
#     #   Name = "dev"
#     # }
#   tags = {
#       Name = "dev-${count.index}"
#     }
# }

variable "env" {
    type = list(string)
    default = [ "dev","prod"]
  
}

resource "aws_instance" "name" {
    ami = "ami-0d176f79571d18a8f"
    instance_type = "m7i-flex.large"
    count = length(var.env)
    # tags = {
    #   Name = "dev"
    # }
  tags = {
      Name = var.env[count.index]
    }
}
