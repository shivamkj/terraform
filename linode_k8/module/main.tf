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
  token = var.linode_config.api_token
}

provider "helm" {
  kubernetes {
    config_path = module.k8_shared.kube_config_path
  }
}

variable "linode_config" {
  type = object({
    api_token = string
  })
  sensitive = true
}

variable "k8_shared_config" { sensitive = true }
variable "k8_cluster_config" { sensitive = true }
variable "node_pool" {}

resource "linode_lke_cluster" "k8_cluster" {
  label       = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}"
  region      = var.k8_cluster_config.region
  k8s_version = var.k8_cluster_config.k8_version

  pool {
    type  = var.node_pool.size
    count = var.node_pool.min_nodes

    autoscaler {
      min = var.node_pool.min_nodes
      max = var.node_pool.max_nodes
    }
  }
}

module "k8_shared" {
  kube_config_content = base64decode(linode_lke_cluster.k8_cluster.kubeconfig)
  depends_on          = [linode_lke_cluster.k8_cluster]

  source           = "../../k8_shared"
  k8_shared_config = var.k8_shared_config
  argo_cd          = true
}


