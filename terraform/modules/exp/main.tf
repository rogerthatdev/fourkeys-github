locals {
  repository_name   = split("/", replace(var.github_repository_url, "/(.*github.com/)/", ""))[1]
  repository_owner  = split("/", replace(var.github_repository_url, "/(.*github.com/)/", ""))[0]
  test_build_config = yamldecode(templatefile("${path.module}/build/test.cloudbuild.yaml", {}))
}

output "test" {
  value = local.test_build_config
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
      for_each = local.test_build_config.steps
      content {
        args = step.value.args
        name = step.value.name
      }
    }
  }
  substitutions = {}
}


