terraform {
  backend "s3" {
    bucket = "sulthanpuuuriiii1234"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}
