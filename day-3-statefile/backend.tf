terraform {
  backend "s3" {
    bucket = "sulthanpuuuriiii"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}
