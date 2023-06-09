variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  type = string
}

######################### EC2 Config #########################

variable "ami" { # AMI (Amazon Machine Image) for EC2
  type    = string
  default = "ami-0f5ee92e2d63afc18" # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type (ap-south-1 region)
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
