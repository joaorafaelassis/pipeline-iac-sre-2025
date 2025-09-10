

resource "google_compute_subnetwork" "custom-subnet" {
  name          = "${var.environment}-subnet"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = google_compute_network.custom-vpc.id
  provider                = google-beta
}

resource "google_compute_network" "custom-vpc" {
  name                    = "${var.environment}-vpc"
  auto_create_subnetworks = false
  provider                = google-beta
}

# Create an IP address
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.custom-vpc.id
  provider                = google-beta
}

# Create a private connection
resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.custom-vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
  provider                = google-beta
}

