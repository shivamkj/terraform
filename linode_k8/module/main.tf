resource "linode_lke_cluster" "k8_cluster" {
  k8s_version = "1.26"
  label       = "shivam-k8-${var.env_name}"
  region      = "ap-west"
  tags        = [var.env_name]

  pool {
    type  = "g6-standard-1"
    count = 2
  }
}

locals {
  kube_config_path = "kube-config-${var.env_name}"
}

resource "local_file" "kubeconfig" {
  filename   = local.kube_config_path
  content    = base64decode(linode_lke_cluster.k8_cluster.kubeconfig)
  depends_on = [linode_lke_cluster.k8_cluster]
}

module "helm_installation" {
  source     = "../../helm_module"
  depends_on = [linode_lke_cluster.k8_cluster, local_file.kubeconfig]

  ingress_name     = "nginx-community"
  cert_manager     = true
  keda_auto_scaler = true
}

