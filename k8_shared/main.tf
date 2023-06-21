terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

locals {
  kube_config_path = "kube-config-${var.k8_shared_config.env}"
}

resource "local_sensitive_file" "kubeconfig" {
  filename        = local.kube_config_path
  content         = var.kube_config_content
  file_permission = 600
}
