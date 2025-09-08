output "network_self_link" {
  value = google_compute_network.custom-vpc.self_link
}

output "subnet_self_link" {
  value = google_compute_subnetwork.custom-subnet.self_link
}