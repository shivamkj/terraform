terraform {
  required_version = ">= 1.4.6"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.28.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_access_token
}

provider "helm" {
  kubernetes {
    config_path = module.k8_shared.kube_config_path
  }
}

resource "digitalocean_kubernetes_cluster" "k8_cluster" {
  name    = "${var.k8_config.project_name}-${var.k8_config.env}"
  region  = var.do_region
  version = var.k8_version

  node_pool {
    name       = var.doks_node_pool.name
    size       = var.doks_node_pool.size
    min_nodes  = var.doks_node_pool.min_nodes
    max_nodes  = var.doks_node_pool.max_nodes
    auto_scale = true
  }
}

module "k8_shared" {
  source              = "../../k8_shared"
  kube_config_content = digitalocean_kubernetes_cluster.k8_cluster.kube_config[0].raw_config
  depends_on          = [digitalocean_kubernetes_cluster.k8_cluster]
  k8_config           = var.k8_config

  argo_cd = true
}
