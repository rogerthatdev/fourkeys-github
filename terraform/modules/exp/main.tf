locals {
  repository_name   = split("/", replace(var.github_repository_url, "/(.*github.com/)/", ""))[1]
  repository_owner  = split("/", replace(var.github_repository_url, "/(.*github.com/)/", ""))[0]
  test_build_config = yamldecode(templatefile("${path.module}/cloudbuild/test.cloudbuild.yaml", {"test" = "a test variable via tf temlatefile()"}))
  pr_build_config   = yamldecode(templatefile("${path.module}/cloudbuild/pr.cloudbuild.yaml", {}))
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


resource "google_cloudbuild_trigger" "new_pr" {
  project     = var.project_id
  location    = var.region
  name        = "test-new-pr"
  description = ""

  github {
    name  = local.repository_name
    owner = local.repository_owner
    pull_request {
      branch = "main"
      comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
      invert_regex = false
    }
  }

  build {
    images        = []
    substitutions = {}
    tags          = []
    dynamic "step" {
      for_each = local.pr_build_config.steps
      content {
        args = step.value.args
        name = step.value.name
      }
    }
  }
  substitutions = {}
}