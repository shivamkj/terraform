variable "do_config" { sensitive = true }
variable "k8_shared_config" { sensitive = true }
variable "k8_cluster_config" { sensitive = true }
variable "node_pool" {}

module "do_k8_cluster" {
  source            = "./module"
  do_config         = var.do_config
  k8_shared_config  = var.k8_shared_config
  k8_cluster_config = var.k8_cluster_config
  node_pool         = var.node_pool
}
