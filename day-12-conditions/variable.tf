variable "create_instance" {
  description = "Whether to create an EC2 instance"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment type"
  type        = string
  default     = "dev"
}