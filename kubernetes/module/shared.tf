terraform {
  required_version = ">= 1.4.6"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.28.1"
    }

    linode = {
      source  = "linode/linode"
      version = "2.4.0"
    }

    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.22.0"
    }

    vultr = {
      source  = "vultr/vultr"
      version = "2.15.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = module.k8_shared.kube_config_path
  }
}

module "k8_shared" {
  source              = "./shared"
  kube_config_content = local.is_vultr ? base64decode(vultr_kubernetes.k8_cluster[0].kube_config) : (local.is_scaleway ? scaleway_k8s_cluster.k8_cluster[0].kubeconfig[0].config_file : (local.is_linode ? base64decode(linode_lke_cluster.k8_cluster[0].kubeconfig) : local.is_digital_ocean ? digitalocean_kubernetes_cluster.k8_cluster[0].kube_config[0].raw_config : null))
  depends_on          = [vultr_kubernetes.k8_cluster, scaleway_k8s_cluster.k8_cluster, linode_lke_cluster.k8_cluster, digitalocean_kubernetes_cluster.k8_cluster]
  k8_shared_config    = var.k8_shared_config
  argo_cd             = true
}
