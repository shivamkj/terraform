provider "vultr" {
  api_key = var.vultr_config.api_key
}

provider "helm" {
  alias = "vultr"
  kubernetes {
    config_path = module.k8_shared_vultr[0].kube_config_path
  }
}

variable "vultr_config" {
  type = object({
    api_key = string
  })

  default   = { api_key = "" }
  sensitive = true
}

locals {
  is_vultr = var.cloud_provider == "vultr"
}

resource "vultr_kubernetes" "k8_cluster" {
  count   = local.is_vultr ? 1 : 0
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
