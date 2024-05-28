# ______________________________________________________________________ROUTES__________________________________________________________________________________________________________
resource "google_compute_route" "app1_route" {
  name             = "app1-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.app1.name
  next_hop_gateway = "default-internet-gateway"
}

# ______________________________________________________________________VPN Gateways and Addresses__________________________________________________________________________________________________________
resource "google_compute_vpn_gateway" "europe_vpn_gateway" {
  name    = "europe-vpn-gateway"
  network = google_compute_network.app1.name
  region  = "europe-west2"
}

resource "google_compute_address" "europe_vpn_gateway_ip" {
  name   = "europe-vpn-gateway-ip"
  region = "europe-west2"
}

resource "google_compute_vpn_gateway" "us_vpn_gateway" {
  name    = "us-vpn-gateway"
  network = google_compute_network.app1.name
  region  = "us-central1"
}

resource "google_compute_address" "us_vpn_gateway_ip" {
  name   = "us-vpn-gateway-ip"
  region = "us-central1"
}

resource "google_compute_forwarding_rule" "europe_vpn_gateway_forwarding_rule_udp500" {
  name        = "europe-vpn-gateway-forwarding-rule-udp500"
  region      = "europe-west2"
  target      = google_compute_vpn_gateway.europe_vpn_gateway.self_link
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.europe_vpn_gateway_ip.address
}

resource "google_compute_forwarding_rule" "us_vpn_gateway_forwarding_rule_udp500" {
  name        = "us-vpn-gateway-forwarding-rule-udp500"
  region      = "us-central1"
  target      = google_compute_vpn_gateway.us_vpn_gateway.self_link
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.us_vpn_gateway_ip.address
}

resource "google_compute_forwarding_rule" "europe_vpn_gateway_forwarding_rule_udp4500" {
  name        = "europe-vpn-gateway-forwarding-rule-udp4500"
  region      = "europe-west2"
  target      = google_compute_vpn_gateway.europe_vpn_gateway.self_link
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.europe_vpn_gateway_ip.address
}

resource "google_compute_forwarding_rule" "us_vpn_gateway_forwarding_rule_udp4500" {
  name        = "us-vpn-gateway-forwarding-rule-udp4500"
  region      = "us-central1"
  target      = google_compute_vpn_gateway.us_vpn_gateway.self_link
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.us_vpn_gateway_ip.address
}

resource "google_compute_forwarding_rule" "europe_vpn_gateway_forwarding_rule_esp" {
  name        = "europe-vpn-gateway-forwarding-rule-esp"
  region      = "europe-west2"
  target      = google_compute_vpn_gateway.europe_vpn_gateway.self_link
  ip_protocol = "ESP"
  ip_address  = google_compute_address.europe_vpn_gateway_ip.address
}

resource "google_compute_forwarding_rule" "us_vpn_gateway_forwarding_rule_esp" {
  name        = "us-vpn-gateway-forwarding-rule-esp"
  region      = "us-central1"
  target      = google_compute_vpn_gateway.us_vpn_gateway.self_link
  ip_protocol = "ESP"
  ip_address  = google_compute_address.us_vpn_gateway_ip.address
}

resource "google_compute_vpn_tunnel" "europe_to_us_tunnel" {
  name                    = "europe-to-us-tunnel"
  peer_ip                 = google_compute_address.us_vpn_gateway_ip.address
  shared_secret           = "armtestingtask3"
  region                  = "europe-west2"
  target_vpn_gateway      = google_compute_vpn_gateway.europe_vpn_gateway.self_link
  local_traffic_selector  = ["10.210.1.0/24"]
  remote_traffic_selector = ["172.16.4.0/24", "172.16.88.0/24"]

  depends_on = [
    google_compute_forwarding_rule.europe_vpn_gateway_forwarding_rule_udp500,
    google_compute_forwarding_rule.europe_vpn_gateway_forwarding_rule_udp4500,
  ]
}

resource "google_compute_vpn_tunnel" "us_to_europe_tunnel" {
  name                    = "us-to-europe-tunnel"
  peer_ip                 = google_compute_address.europe_vpn_gateway_ip.address
  shared_secret           = "armtestingtask3"
  region                  = "us-central1"
  target_vpn_gateway      = google_compute_vpn_gateway.us_vpn_gateway.self_link
  local_traffic_selector  = ["172.16.4.0/24", "172.16.88.0/24"]
  remote_traffic_selector = ["10.210.1.0/24"]

  depends_on = [
    google_compute_forwarding_rule.us_vpn_gateway_forwarding_rule_udp500
  ]
}

