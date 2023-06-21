terraform {
  required_version = ">= 1.4.6"

  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.4.0"
    }
  }
}

provider "linode" {
  token = var.linode_api_token
}

provider "helm" {
  kubernetes {
    config_path = module.k8_shared.kube_config_path
  }
}

resource "linode_lke_cluster" "k8_cluster" {
  k8s_version = "1.26"
  label       = "shivam-k8-${var.env_name}"
  region      = "ap-west"
  tags        = [var.env_name]

  pool {
    type  = "g6-standard-1"
    count = 2
  }
}

module "k8_shared" {
  source              = "../../k8_shared"
  kube_config_content = base64decode(linode_lke_cluster.k8_cluster.kubeconfig)
  depends_on          = [linode_lke_cluster.k8_cluster]
  k8_config           = var.k8_config

  argo_cd = true
}


