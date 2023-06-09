terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # backend "s3" {
  #   bucket         = "terraform-state"
  #   key            = "aws_ec2_application/"
  #   region         = var.region
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-locking"
  # }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


module "ec2_production_application" {
  source = "./module"

  app_name    = "terraform-app"
  environment = "dev"
}

output "lb_address" {
  value = module.ec2_production_application.application_lb_addr
}
