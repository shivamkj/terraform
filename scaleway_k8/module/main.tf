terraform {
  required_version = ">= 1.4.6"
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.22.0"
    }
  }
}

provider "scaleway" {
  access_key = var.scaleway_config.access_key
  secret_key = var.scaleway_config.secret_key
  region     = var.k8_cluster_config.region
  zone       = var.scaleway_config.zone
  project_id = var.scaleway_config.project_id
}

provider "helm" {
  kubernetes {
    config_path = module.k8_shared.kube_config_path
  }
}

variable "scaleway_config" {
  type = object({
    access_key = string
    secret_key = string
    zone       = string
    project_id = string
  })
  sensitive = true
}

variable "k8_shared_config" { sensitive = true }
variable "k8_cluster_config" { sensitive = true }
variable "node_pool" {}

resource "scaleway_k8s_cluster" "k8_cluster" {
  name                        = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}"
  version                     = var.k8_cluster_config.k8_version
  cni                         = "cilium"
  delete_additional_resources = true
  # private_network_id          = scaleway_vpc_private_network.regional_pn.id
}

resource "scaleway_k8s_pool" "node_pool" {
  cluster_id  = scaleway_k8s_cluster.k8_cluster.id
  name        = "${var.k8_shared_config.project_name}-${var.k8_shared_config.env}-node"
  node_type   = var.node_pool.size
  size        = var.node_pool.min_nodes
  autoscaling = true
  autohealing = true
  min_size    = var.node_pool.min_nodes
  max_size    = var.node_pool.max_nodes
}

# resource "scaleway_vpc" "vpc" {
#   name = "test-vpc"
#   tags = ["terraform", "vpc"]
# }

# resource "scaleway_vpc_private_network" "regional_pn" {
#   name        = "my_regiona_pn"
#   is_regional = true
#   vpc_id      = scaleway_vpc.vpc.id
# }

module "k8_shared" {
  kube_config_content = scaleway_k8s_cluster.k8_cluster.kubeconfig[0].config_file
  depends_on          = [scaleway_k8s_cluster.k8_cluster]

  source           = "../../k8_shared"
  k8_shared_config = var.k8_shared_config
  argo_cd          = true
}


