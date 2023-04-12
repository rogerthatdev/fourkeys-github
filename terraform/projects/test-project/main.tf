module "fourkeys-experimental" {
    source = "../../modules/exp"
    project_id = "samples-four-keys"
    github_repository_url = "github.com/rogerthatdev/fourkeys-github"
}

output "test" {
    value = module.fourkeys-experimental.test
}