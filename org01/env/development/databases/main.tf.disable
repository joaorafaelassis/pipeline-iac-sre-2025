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
  private_network = try(data.terraform_remote_state.vpc.outputs.network_self_link, "https://www.googleapis.com/compute/v1/projects/mock-project/global/networks/mock-vpc")
}


module "sql" {
    source = "../../../modules/sql"
    database_version = local.env.database_version
    environment = local.env.environment_name
    private_network = local.private_network
    region = local.org.region
    tier = local.env.database_tier
}



