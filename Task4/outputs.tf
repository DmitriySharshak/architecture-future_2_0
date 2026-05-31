output "kafka_private_ips" {
  description = "Private IPs of Kafka VMs"
  value       = yandex_compute_instance.kafka[*].network_interface[0].ip_address
}

output "clickhouse_private_ips" {
  description = "Private IPs of ClickHouse VMs"
  value       = yandex_compute_instance.clickhouse[*].network_interface[0].ip_address
}

output "data_portal_public_ip" {
  description = "Public IP of Data Portal VM"
  value       = yandex_compute_instance.data_portal.network_interface[0].nat_ip_address
}

#output "clickhouse_data_disks" {
#  description = "Additional data disks for ClickHouse"
#  value       = yandex_compute_disk.clickhouse_data[*].id
#}