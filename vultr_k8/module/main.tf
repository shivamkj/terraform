terraform {
  required_version = ">= 1.4.6"
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.15.1"
    }
  }
}

provider "vultr" {
  api_key = var.vultr_config.api_key
}

provider "helm" {
  kubernetes {
    config_path = module.k8_shared.kube_config_path
  }
}

variable "vultr_config" {
  type = object({
    api_key = string
  })
  sensitive = true
}

variable "k8_shared_config" { sensitive = true }
variable "k8_cluster_config" { sensitive = true }
variable "node_pool" {}

resource "vultr_kubernetes" "k8_cluster" {
  label   = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}"
  region  = var.k8_cluster_config.region
  version = var.k8_cluster_config.k8_version

  node_pools {
    node_quantity = var.node_pool.min_nodes
    plan          = var.node_pool.size
    label         = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}-node"
    auto_scaler   = true
    min_nodes     = var.node_pool.min_nodes
    max_nodes     = var.node_pool.max_nodes
  }
}

module "k8_shared" {
  kube_config_content = base64decode(vultr_kubernetes.k8_cluster.kube_config)
  depends_on          = [vultr_kubernetes.k8_cluster]

  source           = "../../k8_shared"
  k8_shared_config = var.k8_shared_config
  argo_cd          = true
}
