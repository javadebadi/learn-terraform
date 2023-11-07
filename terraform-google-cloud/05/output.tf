output "instance_ip_addr_0" {
    value = google_compute_instance.these.0.network_interface.0.access_config.0.nat_ip
}

output "instance_ip_addr_1" {
    value = google_compute_instance.these.1.network_interface.0.access_config.0.nat_ip
}

output "instance_ip_addr_2" {
    value = google_compute_instance.these.2.network_interface.0.access_config.0.nat_ip
}
