variable "gcp_project" {
  type = string
}

variable "terraform_bucket" {
  type = string
}

provider "google" {
  project = var.gcp_project
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = var.terraform_bucket
    prefix = "gitlab/gitlab-ci-test/terraform.tfstate"
  }
}

resource "google_storage_bucket" "made-it" {
  name          = "YOUR-BUCKET-NAME-CREATED-BY-GITLAB-CD-AND-TERRAFORM"
  location      = "US"
  storage_class = "STANDARD"
}
