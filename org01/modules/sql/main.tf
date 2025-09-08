resource "google_sql_database_instance" "main" {
  name                = "${var.environment}-database"
  database_version    = var.database_version
  region              = var.region
  deletion_protection = false
  
  

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = var.tier
    ip_configuration {
      private_network = var.private_network
      ssl_mode = "ENCRYPTED_ONLY"
    }
  }
}
