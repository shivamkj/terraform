terraform {
  required_version = ">= 1.4.6"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = local.kube_config_path
  }
}

provider "linode" {
  token = var.linode_api_token
}
