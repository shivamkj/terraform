provider "scaleway" {
  access_key = var.scaleway_config.access_key
  secret_key = var.scaleway_config.secret_key
  region     = var.scaleway_config.region
  zone       = var.scaleway_config.zone
  project_id = var.scaleway_config.project_id
}

variable "scaleway_config" {
  type = object({
    access_key = string
    secret_key = string
    region     = string
    zone       = string
    project_id = string
  })

  # Sample values added to avoid validation error, if scaleway wasn't used
  default = {
    access_key = "SCWP54HNETKQ3MKQQYJW",
    secret_key = "a13f5731-58dd-4f61-ad68-0a5f6d1351e9",
    region     = "fr-par"
    zone       = "fr-par-2",
    project_id = "a13f5731-58dd-4f61-ad68-0a5f6d1351e9"
  }
  sensitive = true
}

locals {
  is_scaleway = var.cloud_provider == "scaleway"
}

resource "scaleway_k8s_cluster" "k8_cluster" {
  count                       = local.is_scaleway ? 1 : 0
  name                        = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}"
  version                     = var.k8_cluster_config.k8_version
  cni                         = "cilium"
  delete_additional_resources = true
  private_network_id          = scaleway_vpc_private_network.regional_pn[count.index].id
}

resource "scaleway_k8s_pool" "node_pool" {
  count       = local.is_scaleway ? 1 : 0
  cluster_id  = scaleway_k8s_cluster.k8_cluster[count.index].id
  name        = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}-node"
  node_type   = var.node_pool.size
  size        = var.node_pool.min_nodes
  autoscaling = true
  autohealing = true
  min_size    = var.node_pool.min_nodes
  max_size    = var.node_pool.max_nodes
}

resource "scaleway_vpc" "vpc" {
  count = local.is_scaleway ? 1 : 0
  name  = "test-vpc"
  tags  = ["terraform", "vpc"]
}

resource "scaleway_vpc_private_network" "regional_pn" {
  count       = local.is_scaleway ? 1 : 0
  name        = "my_regiona_pn"
  is_regional = true
  vpc_id      = scaleway_vpc.vpc[count.index].id
}
