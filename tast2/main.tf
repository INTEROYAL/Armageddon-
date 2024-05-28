terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.25.0"
    }
  }
}

provider "google" {
  credentials = file("gcp-cli-testing-b4eced71061d.json")
  project     = "gcp-cli-testing"
  region      = "us-central1"
}

# VPC
resource "google_compute_network" "vpc_network" {
  name                    = "task2vpc"
  auto_create_subnetworks = false
}

# Subnet within VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "subnettt"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.72.1.0/24"
  region        = "us-central1"
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# VM
resource "google_compute_instance" "task2vm" {
  name         = "task2vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    auto_delete = true
    device_name = "task2vm"
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240515"
      size  = 10
      type  = "pd-balanced"
    }
    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  metadata = {
    startup-script = "#!/bin/bash\napt update\napt install -y apache2\nsystemctl start apache2\nsystemctl enable apache2\nMETADATA_URL=\"http://metadata.google.internal/computeMetadata/v1\"\nMETADATA_FLAVOR_HEADER=\"Metadata-Flavor: Google\"\nlocal_ipv4=$(curl -H \"$${METADATA_FLAVOR_HEADER}\" -s \"$${METADATA_URL}/instance/network-interfaces/0/ip\")\nzone=$(curl -H \"$${METADATA_FLAVOR_HEADER}\" -s \"$${METADATA_URL}/instance/zone\")\nproject_id=$(curl -H \"$${METADATA_FLAVOR_HEADER}\" -s \"$${METADATA_URL}/project/project-id\")\nnetwork_tags=$(curl -H \"$${METADATA_FLAVOR_HEADER}\" -s \"$${METADATA_URL}/instance/tags\")\ncat <<HTML > /var/www/html/index.html\n<html><head><title>Welcome to Task 2 VPC+VM Webpage</title><style>body { background-color: rgb(0, 0, 0); color: white; }</style></head><body><h1>Welcome to Task 2 VPC+VM Webpage> </h1><p> The spoon is not real</p></body></html>\n<h2></h2>\n<h3></h3>\n<p><b>Instance Name:</b> $(hostname -f)</p>\n<p><b>Instance Private IP Address: </b> $local_ipv4</p>\n<p><b>Zone: </b> $zone</p>\n<p><b>Project ID:</b> $project_id</p>\n<p><b>Network Tags:</b> $network_tags</p></body></html>"
  }

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link

    access_config {
      network_tier = "STANDARD"
    }
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "603446210109-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server"]
}

# Outputs
output "instance_ip_address" {
  value = google_compute_instance.task2vm.network_interface.0.access_config.0.nat_ip
}

output "vpc" {
  value = google_compute_network.vpc_network.name
}

output "subnet_info" {
  value = google_compute_subnetwork.subnet.self_link
}

output "instance_internal_ip" {
  value = google_compute_instance.task2vm.network_interface.0.network_ip
}
