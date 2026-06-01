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

# Настройки для Kafka VM
variable "kafka_instance_count" {
  description = "Number of Kafka instances"
  type        = number
  default     = 1
}

variable "kafka_resources" {
  description = "Resources for Kafka VM"
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 4
  }
}

variable "kafka_boot_disk" {
  description = "Boot disk configuration for Kafka"
  type = object({
    size = number
    type = string
  })
  default = {
    size = 50
    type = "network-ssd"
  }
}

# Настройки для ClickHouse VM
variable "clickhouse_instance_count" {
  description = "Number of ClickHouse instances"
  type        = number
  default     = 1
}

variable "clickhouse_resources" {
  description = "Resources for ClickHouse VM"
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 4
    memory = 16
  }
}

variable "clickhouse_boot_disk" {
  description = "Boot disk configuration for ClickHouse"
  type = object({
    size = number
    type = string
  })
  default = {
    size = 50
    type = "network-ssd"
  }
}

variable "clickhouse_data_disks" {
  description = "Additional data disks for ClickHouse"
  type = object({
    count = number
    size  = number
    type  = string
  })
  default = {
    count = 0
    size  = 100
    type  = "network-hdd"
  }
}

# Настройки для Data Portal VM
variable "portal_resources" {
  description = "Resources for Data Portal VM"
  type = object({
    cores  = number
    memory = number
  })
  default = {
    cores  = 2
    memory = 4
  }
}

variable "portal_boot_disk" {
  description = "Boot disk configuration for Data Portal"
  type = object({
    size = number
    type = string
  })
  default = {
    size = 30
    type = "network-ssd"
  }
}
