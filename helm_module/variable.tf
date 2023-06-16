variable "argo_cd" {
  type        = bool
  description = "Installs Argo CD in K8 cluster"
  default     = false
}

variable "nginx_ingress" {
  type        = bool
  description = "Installs community edition built nginx ingress for Kubernetes"
  default     = false
}

variable "cert_manager" {
  type        = bool
  description = "Installs cert-manager to automate the management and issuance of TLS certificates"
  default     = false
}

variable "keda_auto_scaler" {
  type        = bool
  description = "Installs Keda auto scaler with HTTP add-on which supports scale to 0 based on http requests"
  default     = false
}

