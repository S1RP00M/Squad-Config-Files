resource "google_compute_instance" "squad_server" {
  project      = "sda-squad-server"
  name         = "squad-sever"
  machine_type = "e2-standard-2"
  zone         = "asia-southeast1-a"

  boot_disk {
    initialize_params {
      image = "windows-server-2025-datacenter"  # อาจต้องตรวจสอบให้แน่ใจว่า image นี้มีใน Google Cloud
      size  = 100  # ขนาดดิสก์ 100 GB
      type  = "pd-balanced"  # แบบของ Persistent Disk ที่เลือกคือ Balanced Persistent Disk
    }
  }

  network_interface {
    network = "default"
    access_config {
      # Allow external IP
    }
  }

  metadata = {
    enable-ip-forwarding = "true"  # เปิด IP Forwarding
  }

  # การตั้งค่า Network Firewall Rules สำหรับ Allow HTTP และ HTTPS traffic
  tags = ["http-server", "https-server"]

  # เปิด HTTP และ HTTPS traffic
  allow_http = true
  allow_https = true
}
