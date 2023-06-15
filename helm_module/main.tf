## https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx
resource "helm_release" "ingress-nginx" {
  count      = var.ingress_name == "nginx-community" ? 1 : 0
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.0"
}

## https://artifacthub.io/packages/helm/cert-manager/cert-manager
resource "helm_release" "cert-m" {
  count      = var.cert_manager ? 1 : 0
  name       = "cert-m"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.12.1"

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
}

## https://artifacthub.io/packages/keda-scaler/keda-official-external-scalers/keda-add-ons-http
resource "helm_release" "keda-add-on-http" {
  count      = var.keda_auto_scaler ? 1 : 0
  depends_on = [helm_release.keda]
  name       = "keda-http-add-on"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda-add-ons-http"
  version    = "0.4.1"
}
