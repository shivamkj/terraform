####    VARIABLES    ####

variable "region" {
  description = "Region for the AWS Project to use for deployment"
  default     = "ap-south-1"
}

# variable "aws_access_key" {
#   type      = string
#   sensitive = true
# }

# variable "aws_secret_key" {
#   type      = string
#   sensitive = true
# }

variable "aws_profile" {
  type = string
}

variable "aws_availability_zone" {
  type = string
}

variable "cidr_blocks" {
  type = list(object({
    cidr_block = string
    used_in    = string
  }))
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}

####    RESOURCES    ####

resource "aws_vpc" "custom-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name : "custom-vpc"
  }
}

resource "aws_subnet" "custom-subnet-1" {
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = var.cidr_blocks[1].cidr_block
  availability_zone = var.aws_availability_zone
  tags = {
    Name : "custom-subnet-1"
  }
}

data "aws_vpc" "current_vpc" {
  default = true
}

resource "aws_subnet" "custom-subnet-2" {
  vpc_id            = data.aws_vpc.current_vpc.id
  cidr_block        = var.cidr_blocks[2].cidr_block
  availability_zone = var.aws_availability_zone
  tags = {
    Name : "custom-subnet-2"
  }
}

####    OUTPUTS    ###

output "custom-vpc-id" {
  value = aws_vpc.custom-vpc.id
}

output "custom-subnet-1-id" {
  value = aws_subnet.custom-subnet-1.id
}

output "custom-subnet-2-id" {
  value = aws_subnet.custom-subnet-2.id
}
