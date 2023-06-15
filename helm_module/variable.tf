variable "ingress_name" {
  type = string
  validation {
    condition     = can(regex("^(nginx-community|nginx)$", var.ingress_name))
    error_message = "Doesn't support provided Ingress"
  }
}

variable "cert_manager" {
  type        = bool
  description = "Installs cert-manager to automate the management and issuance of TLS certificates"
}

variable "keda_auto_scaler" {
  type        = bool
  description = "Installs Keda auto scaler with HTTP add-on which supports scale to 0 based on http requests"
}

