variable "do_access_token" {
  type      = string
  sensitive = true
}

module "do_k8_cluster" {
  source          = "./module"
  k8_cluster_name = "test"
  # env_name = "dev"
  do_access_token = var.do_access_token
}

