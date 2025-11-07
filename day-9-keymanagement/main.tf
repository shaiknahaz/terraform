# Key Pair
resource "aws_key_pair" "example" {
  key_name   = "task"
  public_key = file("~/.ssh/id_ed25519.pub")
}


resource "aws_instance" "server" {
  ami                         = "ami-02b8269d5e85954ef" # Ubuntu AMI
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.example.key_name
  
}