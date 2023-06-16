terraform {
  required_version = ">= 1.4.6"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.28.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_access_token
}

provider "helm" {
  kubernetes {
    config_path = local.kube_config_path
  }
}
