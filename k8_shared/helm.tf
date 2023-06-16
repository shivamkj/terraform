## https://artifacthub.io/packages/helm/argo/argo-cd
resource "helm_release" "argocd" {
  count            = var.argo_cd ? 1 : 0
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.36.1"
  create_namespace = true
  depends_on       = [local_file.kubeconfig]

  values = [
    templatefile("${path.module}/argo_cd_values.tftpl", {
      argocd_url           = var.k8_config.argo_cd_url
      github_org_name      = var.k8_config.github_org_name
      github_client_id     = var.k8_config.github_client_id
      github_client_secret = sensitive(var.k8_config.github_client_secret)
    })
  ]
}

## https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
resource "helm_release" "ingress-nginx" {
  count      = var.nginx_ingress ? 1 : 0
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.0"
  depends_on = [local_file.kubeconfig]
}

## https://artifacthub.io/packages/helm/cert-manager/cert-manager
resource "helm_release" "cert-m" {
  count      = var.cert_manager ? 1 : 0
  name       = "cert-m"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.12.1"
  depends_on = [local_file.kubeconfig]

  set {
    name  = "installCRDs"
    value = "true"
  }
}

## https://artifacthub.io/packages/helm/kedacore/keda
resource "helm_release" "keda" {
  count      = var.keda_auto_scaler ? 1 : 0
  name       = "keda-core"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.10.2"
  depends_on = [local_file.kubeconfig]
}

## https://artifacthub.io/packages/keda-scaler/keda-official-external-scalers/keda-add-ons-http
resource "helm_release" "keda-add-on-http" {
  count      = var.keda_auto_scaler ? 1 : 0
  name       = "keda-http-add-on"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda-add-ons-http"
  version    = "0.4.1"
  depends_on = [helm_release.keda, local_file.kubeconfig]
}
