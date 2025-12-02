terraform {
  backend "s3" {
    bucket = "sananareshit123"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}
