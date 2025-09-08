module "api" {
    source = "../../modules/api/"
    api_list = local.org.api_list
    project = local.org.project
}

