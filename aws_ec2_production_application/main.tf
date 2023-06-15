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
  domain_name = "dev-app.shivamjha.com"
}

resource "cloudflare_record" "dev_sub_domain_record" {
  zone_id = var.cloudflare_zone_id
  name    = "dev-app"
  value   = module.ec2_production_application.application_lb_addr
  type    = "CNAME"
}

### Cert Validation for issuing SSL for AWS LB
resource "cloudflare_record" "cf_record" {
  for_each = {
    for item in module.ec2_production_application.cert_dns_validation : item.domain_name => {
      name   = item.resource_record_name
      record = item.resource_record_value
      type   = item.resource_record_type
    }
  }

  zone_id         = var.cloudflare_zone_id
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  value           = each.value.record
  ttl             = 1
}
