resource "google_project_service" "project" {
  for_each = toset(var.api_list)
  project  = var.project
  service  = each.value
  disable_on_destroy = false
}
