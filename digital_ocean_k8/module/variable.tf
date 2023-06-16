variable "do_access_token" {
  type      = string
  sensitive = true
}

variable "do_region" {
  type    = string
  default = "blr1"
}

variable "k8_version" {
  type    = string
  default = "1.27.2-do.0"
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

variable "k8_config" { sensitive = true }
