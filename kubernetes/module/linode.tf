provider "linode" {
  token = var.linode_config.api_token
}

variable "linode_config" {
  type = object({
    api_token = string
  })

  default   = { api_token = "" }
  sensitive = true
}

locals {
  is_linode = var.cloud_provider == "linode"
}

resource "linode_lke_cluster" "k8_cluster" {
  count       = local.is_linode ? 1 : 0
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


