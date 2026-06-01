terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.3"
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.default_zone
}

data "yandex_resourcemanager_folder" "current" {
  folder_id = var.yc_folder_id
}

output "folder_info" {
  value = {
    folder_id   = data.yandex_resourcemanager_folder.current.id
    folder_name = data.yandex_resourcemanager_folder.current.name
    cloud_id    = data.yandex_resourcemanager_folder.current.cloud_id
  }
}

# Сеть
resource "yandex_vpc_network" "future_net" {
  name = "future-network"
}

# Подсети
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "ru-central1-a-subnet"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.future_net.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}

resource "yandex_vpc_subnet" "subnet_b" {
  name           = "ru-central1-b-subnet"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.future_net.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}

# VM для Kafka (1 шт для теста, без security groups)
resource "yandex_compute_instance" "kafka" {
  count       = var.kafka_instance_count
  name        = "kafka-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores  = var.kafka_resources.cores
    memory = var.kafka_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.kafka_boot_disk.size
      type     = var.kafka_boot_disk.type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_ssh_key_path)}"
  }
}

# VM для ClickHouse (1 шт для теста)
resource "yandex_compute_instance" "clickhouse" {
  count       = var.clickhouse_instance_count
  name        = "clickhouse-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores  = var.clickhouse_resources.cores
    memory = var.clickhouse_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.clickhouse_boot_disk.size
      type     = var.clickhouse_boot_disk.type
    }
  }

  dynamic "secondary_disk" {
    for_each = range(var.clickhouse_data_disks.count)
    content {
      disk_id = yandex_compute_disk.clickhouse_data[count.index][secondary_disk.value].id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_ssh_key_path)}"
  }
}

# VM для Data Portal
resource "yandex_compute_instance" "data_portal" {
  name        = "data-portal"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores  = var.portal_resources.cores
    memory = var.portal_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.ubuntu_image_id
      size     = var.portal_boot_disk.size
      type     = var.portal_boot_disk.type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_ssh_key_path)}"
  }
}