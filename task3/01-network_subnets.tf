
# ______________________________________________________________________Subnets__________________________________________________________________________________________________________


resource "google_compute_network" "app1" {
  name                    = "app1"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "europe_subnet" {
  name                     = "europe-subnet"
  ip_cidr_range            = "10.210.1.0/24"
  region                   = "europe-west2"
  network                  = google_compute_network.app1.name
  private_ip_google_access = false
}

resource "google_compute_subnetwork" "us_west_subnet" {
  name                     = "us-west-subnet"
  ip_cidr_range            = "172.16.4.0/24"
  region                   = "us-west1"
  network                  = google_compute_network.app1.name
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "us_central_subnet" {
  name                     = "us-central-subnet"
  ip_cidr_range            = "172.16.88.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.app1.name
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "asia_subnet" {
  name                     = "asia-subnet"
  ip_cidr_range            = "192.168.202.0/24"
  region                   = "asia-northeast1"
  network                  = google_compute_network.app1.name
  private_ip_google_access = true
}