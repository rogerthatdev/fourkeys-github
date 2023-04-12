variable "project_id" {
  type        = string
  description = "project to deploy four keys resources to"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "Region to deploy fource keys resources in."
}

variable "enable_apis" {
  type        = bool
  description = "Toggle to include required APIs."
  default     = true
}

variable "github_repository_url" {
  type        = string
  description = "URL of connected GitHub repository (https://github.com/repo_owner/repo_name)"
}