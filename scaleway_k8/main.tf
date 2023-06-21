variable "scaleway_config" { sensitive = true }
variable "k8_shared_config" { sensitive = true }
variable "k8_cluster_config" { sensitive = true }
variable "node_pool" {}

module "linode_k8_cluster" {
  scaleway_config = var.scaleway_config

  source            = "./module"
  k8_shared_config  = var.k8_shared_config
  k8_cluster_config = var.k8_cluster_config
  node_pool         = var.node_pool
}
