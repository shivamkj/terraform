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
  token = var.do_config.access_token
}

provider "helm" {
  kubernetes {
    config_path = module.k8_shared.kube_config_path
  }
}

variable "do_config" {
  type = object({
    access_token = string
  })
  sensitive = true
}

variable "k8_shared_config" { sensitive = true }
variable "k8_cluster_config" { sensitive = true }
variable "node_pool" {}

resource "digitalocean_kubernetes_cluster" "k8_cluster" {
  name    = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}"
  region  = var.k8_cluster_config.region
  version = var.k8_cluster_config.k8_version

  node_pool {
    name       = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}-node"
    size       = var.node_pool.size
    min_nodes  = var.node_pool.min_nodes
    max_nodes  = var.node_pool.max_nodes
    auto_scale = true
  }
}

module "k8_shared" {
  kube_config_content = digitalocean_kubernetes_cluster.k8_cluster.kube_config[0].raw_config
  depends_on          = [digitalocean_kubernetes_cluster.k8_cluster]

  source           = "../../k8_shared"
  k8_shared_config = var.k8_shared_config
  argo_cd          = true
}
