region      = "ap-south-1"
aws_profile = "dev"
# aws_access_key        = "ACCESS_KEY"
# aws_secret_key        = "SECRET_KEY"
aws_availability_zone = "ap-south-1a"
cidr_blocks = [
  { cidr_block = "0.0.0.0/00", used_in = "custom-vpc" },
  { cidr_block = "0.0.0.0/00", used_in = "custom-subnet-1" },
  { cidr_block = "0.0.0.0/00", used_in = "custom-subnet-2" },
]
