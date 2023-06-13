terraform {
  required_version = ">= 0.15"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}

provider "linode" {
  token = var.linode_api_token
}

provider "helm" {
  kubernetes {
    config_path = "kube-config-${var.env_name}"
  }
}

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

resource "local_file" "kubeconfig" {
  filename   = "kube-config-${var.env_name}"
  content    = base64decode(linode_lke_cluster.k8_cluster.kubeconfig)
  depends_on = [linode_lke_cluster.k8_cluster]
}

resource "helm_release" "ingress-nginx" {
  depends_on = [local_file.kubeconfig]
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
}

resource "helm_release" "cert-m" {
  depends_on = [local_file.kubeconfig]
  name       = "cert-m"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.12.0"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "keda" {
  depends_on = [local_file.kubeconfig]
  name       = "keda-core"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
}


resource "helm_release" "keda-add" {
  depends_on = [local_file.kubeconfig, helm_release.keda]
  name       = "keda-http-add-on"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda-add-ons-http"
}
