# ===================== DO CONFIG VARS =======================
variable "do_access_token" {
  type      = string
  sensitive = true
}

# ===================== DOKS CONFIG VARS =======================

variable "k8_cluster_name" {
  type = string
}

variable "k8_version" {
  type    = string
  default = "1.27.2-do.0"
}

variable "doks_cluster_region" {
  type    = string
  default = "blr1"
}

variable "doks_node_pool" {
  type = map(any)

  default = {
    name      = "bootstrapper-default"
    size      = "s-2vcpu-4gb"
    max_nodes = 3
    min_nodes = 1
  }
  description = "DOKS cluster default node pool configuration"
}

variable "env_name" {
  description = "The environment for the LKE cluster"
  default     = "dev"
}
