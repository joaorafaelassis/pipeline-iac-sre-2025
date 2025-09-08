//gcloud auth application-default login --no-launch-browser

terraform {
  required_providers {
    google = {
      version = "~> 6.0.0"
    }
  }
  required_version = "> 1.2"
  	 backend "gcs" {}
}


provider "google" {
  project = local.org.project
  region  = local.org.region
}

locals {
  org = yamldecode(file("../../org.yaml")).org
}