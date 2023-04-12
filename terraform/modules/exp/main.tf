locals {
  repository_name  = split("/", replace(var.github_repository_url, "/(.*github.com/)/", ""))[1]
  repository_owner = split("/", replace(var.github_repository_url, "/(.*github.com/)/", ""))[0]
  template_vars    = { test = "value" }
  steps            = yamldecode(templatefile("${path.module}/build/test.cloudbuild.yaml", local.template_vars))
}

output "test" {
  value = local.steps
}
resource "google_cloudbuild_trigger" "test_project_capture" {
  project     = var.project_id
  location    = var.region
  name        = "test-project-capture"
  description = ""

  github {
    name  = local.repository_name
    owner = local.repository_owner
    push {
      branch       = "main"
      invert_regex = false
    }
  }

  build {
    images        = []
    substitutions = {}
    tags          = []
    dynamic "step" {
      for_each = local.steps.steps
      content {
        args = step.value.args
        name = step.value.name
      }
    }
  }
  substitutions = {}
}


