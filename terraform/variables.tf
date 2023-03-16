variable "entrypoint_server_count" {
  type    = number
  default = "1"
}

variable "vpn_count" {
  type    = number
  default = "2"
}

variable "docker_ecr" {
  type    = number
  default = "3"
}

variable "region" {
  description = "The AWS region where the EC2 instance should be launched."
  default     = "us-east-1"
}

variable "create_target_instance" {
  description = "Whether to create an EC2 instance or not"
  type        = bool
  default     = true
}

variable "create_entrypoint_instance" {
  description = "Whether to create an EC2 instance or not"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "Specify SSH key to access instance"
  type        = string
  default     = vpn-test
}

