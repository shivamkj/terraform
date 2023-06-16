variable "do_access_token" {
  type      = string
  sensitive = true
}

variable "k8_config" { sensitive = true }

module "do_k8_cluster" {
  source          = "./module"
  do_access_token = var.do_access_token
  k8_config       = var.k8_config
}
