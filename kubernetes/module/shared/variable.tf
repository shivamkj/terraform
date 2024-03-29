variable "kube_config_content" {
  type      = string
  sensitive = true
}

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

# ===================== K8 Module Configuration =======================

variable "k8_shared_config" {
  type = object({
    ## General Config
    env          = string
    project_name = string

    ## Argo CD Configuration
    github_client_id      = string
    github_client_secret  = string
    github_org_name       = string
    argo_cd_url           = string
    github_repo_url       = string
    github_ssh_key        = string
    github_webhook_secret = string
  })

  sensitive = true
}

variable "k8_cluster_config" {
  type = object({
    region     = string
    k8_version = string
  })

  default = {
    region     = "blr1"
    k8_version = "1.27.2-do.0"
  }
}

variable "node_pool" {
  type = object({
    size      = string
    max_nodes = number
    min_nodes = number
  })

  default = {
    size      = "s-2vcpu-4gb"
    max_nodes = 3
    min_nodes = 1
  }
}
