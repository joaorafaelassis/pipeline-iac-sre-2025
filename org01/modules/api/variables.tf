variable "api_list" {
    description = "List the GCP api to be enabled"
    type = list(string)  
}

variable "project" {
    description = "GCP project id"
    type = string 
}