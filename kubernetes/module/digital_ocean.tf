provider "digitalocean" {
  token = var.do_config.access_token
}

variable "do_config" {
  type = object({
    access_token = string
  })

  default   = { access_token = "" }
  sensitive = true
}

locals {
  is_digital_ocean = var.cloud_provider == "digital_ocean"
}


resource "digitalocean_kubernetes_cluster" "k8_cluster" {
  count   = local.is_digital_ocean ? 1 : 0
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
