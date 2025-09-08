module "vpc" {
  source        = "../../../modules/vpc"
  environment   = local.env.environment_name
  ip_cidr_range = local.env.ip_cidr_range
  region        = local.org.region
}

locals {
  env = yamldecode(file("../env.yaml")).env
}
