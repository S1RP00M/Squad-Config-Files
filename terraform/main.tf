resource "google_compute_instance" "squad_server" {
  project      = "sda-squad-server"
  name         = "squad-server"
  machine_type = "e2-standard-2"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "windows-server-2025-dc-v20250212"
      size  = 100  # Disk size 100 GB
      type  = "pd-balanced"  # Persistent disk type
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Allow external IP
    }
  }

  metadata = {
    enable-ip-forwarding = "true"  # Enable IP Forwarding
  }

  tags = ["http-server", "https-server"]  # This associates the instance with the firewall rules
}

resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["http-server"]  # Allows HTTP traffic to instances with the "http-server" tag
}

resource "google_compute_firewall" "allow_https" {
  name    = "allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_tags = ["https-server"]  # Allows HTTPS traffic to instances with the "https-server" tag
}