variable "linode_api_token" {
  type      = string
  sensitive = true
}

variable "k8_config" { sensitive = true }

module "linode_k8_cluster" {
  source           = "./module"
  env_name         = "dev"
  linode_api_token = var.linode_api_token
  k8_config        = var.k8_config
}

