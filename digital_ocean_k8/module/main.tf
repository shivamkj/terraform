resource "digitalocean_kubernetes_cluster" "k8_cluster" {
  name    = "${var.k8_cluster_name}-${var.env_name}"
  region  = var.doks_cluster_region
  version = var.k8_version

  node_pool {
    name       = var.doks_node_pool.name
    size       = var.doks_node_pool.size
    min_nodes  = var.doks_node_pool.min_nodes
    max_nodes  = var.doks_node_pool.max_nodes
    auto_scale = true
  }
}

locals {
  kube_config_path = "kube-config-${var.env_name}"
}

resource "local_file" "kubeconfig" {
  filename   = local.kube_config_path
  content    = digitalocean_kubernetes_cluster.k8_cluster.kube_config[0].raw_config
  depends_on = [digitalocean_kubernetes_cluster.k8_cluster]
}

module "helm_installation" {
  source     = "../../helm_module"
  depends_on = [digitalocean_kubernetes_cluster.k8_cluster, local_file.kubeconfig]

  argo_cd = true
}
