resource "google_compute_instance" "these" {
  provider     = google
  count        = 3
  name         = "${var.server_name}-${count.index}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
        // Ephermal Public IP
    }
  }

  metadata_startup_script = file("startup.sh")
  tags = ["http-server", "https-server"]
}
