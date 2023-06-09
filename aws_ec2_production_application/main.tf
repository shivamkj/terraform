terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
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

provider "cloudflare" {
  api_token = var.cloudflare_token
}

module "ec2_production_application" {
  source = "./module"

  app_name    = "terraform-app"
  environment = "dev"
}

# Add a record to the domain
resource "cloudflare_record" "dev_sub_domain_record" {
  zone_id = var.cloudflare_zone_id
  name    = "dev-app"
  value   = module.ec2_production_application.application_lb_addr
  type    = "CNAME"
}
