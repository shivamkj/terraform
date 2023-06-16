variable "linode_api_token" {
  type      = string
  sensitive = true
}

variable "env_name" {
  description = "The environment for the LKE cluster"
  default     = "dev"
}