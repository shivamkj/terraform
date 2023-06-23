variable "do_config" { sensitive = true }
variable "linode_config" { sensitive = true }
variable "vultr_config" { sensitive = true }
variable "scaleway_config" { sensitive = true }
variable "k8_shared_config" { sensitive = true }

# module "do_k8_cluster" {
#   source           = "./module"
#   cloud_provider   = "digital_ocean"
#   do_config        = var.do_config
#   k8_shared_config = var.k8_shared_config
#   node_pool = {
#     size      = "s-2vcpu-4gb"
#     max_nodes = 3
#     min_nodes = 1
#   }
#   k8_cluster_config = {
#     region     = "blr1"
#     k8_version = "1.27.2-do.0"
#   }
# }

module "linode_k8_cluster" {
  source           = "./module"
  cloud_provider   = "linode"
  linode_config    = var.linode_config
  k8_shared_config = var.k8_shared_config
  node_pool = {
    size      = "g6-standard-1"
    max_nodes = 3
    min_nodes = 1
  }
  k8_cluster_config = {
    region     = "ap-west"
    k8_version = "1.26"
  }
}

# module "vultr_k8_cluster" {
#   source           = "./module"
#   cloud_provider   = "vultr"
#   vultr_config     = var.vultr_config
#   k8_shared_config = var.k8_shared_config
#   k8_cluster_config = {
#     region     = "bom" # Mumbai
#     k8_version = "v1.26.2+2"
#   }
#   node_pool = {
#     size      = "vc2-2c-4gb"
#     max_nodes = 3
#     min_nodes = 1
#   }
# }

# module "scaleway_k8_cluster" {
#   source           = "./module"
#   cloud_provider   = "scaleway"
#   scaleway_config  = var.scaleway_config
#   k8_shared_config = var.k8_shared_config
#   node_pool = {
#     size      = "PRO2-XXS"
#     max_nodes = 3
#     min_nodes = 1
#   }
#   k8_cluster_config = {
#     region     = "fr-par"
#     k8_version = "1.27.2"
#   }
# }

