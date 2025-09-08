variable "environment" {
    description = "The environment for the terraform code. The values can be: development, test, staging and production"
    type = string
    validation {
      condition = contains(["development", "test", "staging", "production"], var.environment)
      error_message = "The environment value must be one of those: development, test, staging and production."
    }  
}

variable "ip_cidr_range" {
  description = "The range of internal addresses that are owned by this subnetwork. Provide this property when you create the subnetwork. For example, 10.0.0.0/8 or 192.168.0.0/16. Ranges must be unique and non-overlapping within a network. Only IPv4 is supported."
  type = string
}

variable "region" {
  description = "GCP region for the subnet"
}

