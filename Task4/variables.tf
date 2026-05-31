#variable "yc_token" {
#  description = "Yandex Cloud OAuth token"
#  sensitive   = true
#}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
}

variable "yc_folder_id" {
  description = "Yandex Folder ID"
}

variable "default_zone" {
  description = "Default availability zone"
  default     = "ru-central1-a"
}

variable "ubuntu_image_id" {
  description = "Ubuntu 22.04 image ID"
  default     = "fd804teg9bthv0h96s8v"  # Стандартный ID для Ubuntu 22.04
}

variable "public_ssh_key_path" {
  description = "Path to public SSH key"
  default     = "~/.ssh/id_rsa.pub"
}