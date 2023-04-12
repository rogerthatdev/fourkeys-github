module "project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "13.0.0"
  disable_services_on_destroy = false
  project_id                  = var.project_id
  enable_apis                 = var.enable_apis

  activate_apis = [
    "cloudbuild.googleapis.com",
  ]
}

# resource "time_sleep" "project_services" {
#   depends_on = [
#     module.project_services
#   ]

#   create_duration = "45s"
# }