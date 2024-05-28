
# ______________________________________________________________________VM Instances__________________________________________________________________________________________________________


# ______________________________________________________________________VM-EU__________________________________________________________________________________________________________

resource "google_compute_instance" "europe_instance" {
  name         = "europe-instance"
  machine_type = "e2-medium"
  zone         = "europe-west2-b"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.app1.name
    subnetwork = google_compute_subnetwork.europe_subnet.name
    # Ensure no external IP
    access_config {
      nat_ip = null
    }
  }

  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
  }
}

# ______________________________________________________________________VM-WEST1__________________________________________________________________________________________________________

resource "google_compute_instance" "us_west_instance" {
  name         = "us-west-instance"
  machine_type = "e2-medium"
  zone         = "us-west1-b"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.app1.name
    subnetwork = google_compute_subnetwork.us_west_subnet.name
    access_config {
      nat_ip = null
    }
  }
}

# ______________________________________________________________________VM-CENTRAL__________________________________________________________________________________________________________

resource "google_compute_instance" "us_central_instance" {
  name         = "us-central-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.app1.name
    subnetwork = google_compute_subnetwork.us_central_subnet.name
    access_config {
      nat_ip = null
    }
  }
}

# ______________________________________________________________________VM-ASIA__________________________________________________________________________________________________________

resource "google_compute_instance" "asia_instance" {
  name         = "asia-instance"
  machine_type = "e2-medium"
  zone         = "asia-northeast1-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.app1.name
    subnetwork = google_compute_subnetwork.asia_subnet.name
    access_config {
      nat_ip = null
    }
  }
}



  


 






