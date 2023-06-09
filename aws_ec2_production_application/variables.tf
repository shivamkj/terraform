######################### AWS Provider Config #########################

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "cloudflare_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type = string
}
