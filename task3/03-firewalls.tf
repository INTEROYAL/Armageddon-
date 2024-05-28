# ______________________________________________________________________Firewall Rules__________________________________________________________________________________________________________
resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.app1.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["172.16.4.0/24", "172.16.88.0/24"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.app1.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-rdp" {
  name    = "allow-rdp"
  network = google_compute_network.app1.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["192.168.202.0/24"]
}