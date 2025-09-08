data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    prefix = "terraform/state/${local.env.environment_name}/network"
    bucket = local.org.state_bucket
  }
}

locals {
  env = yamldecode(file("../env.yaml")).env
  #mock value for private_network
  private_subnet = try(data.terraform_remote_state.vpc.outputs.subnet_self_link, "https://www.googleapis.com/compute/v1/projects/mock-project/global/networks/mock-vpc")
}

module "service_accounts" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.5"
  project_id = local.org.project
  names      = [format("%s-%s", "custom-sa", local.env.environment_name)]
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 12.0"

  region       = local.org.region
  project_id   = local.org.project
  subnetwork   = local.private_subnet
  machine_type = local.env.machine_type

  service_account = ({
    email  = module.service_accounts.email
    scopes = ["cloud-platform"]
    }

  )
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "~> 12.0"

  region              = local.org.region
  zone                = local.org.zone
  subnetwork          = local.private_subnet
  num_instances       = 1
  hostname            = format("%s-%s", "gce-instance", local.env.environment_name)
  instance_template   = module.instance_template.self_link
  deletion_protection = false

  access_config = []
}
