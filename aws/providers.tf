locals {
  gcp_project_name   = "GCP_PROJECT_NAME"
  gcp_project_number = "GCP_PROJECT_NUMBER"
  aws_account_id     = "AWS_ACCOUNT_ID"
  gcp_pool_id        = "GCP_POOL_ID"
  gcp_provider_id    = "GCP_PROVIDER_ID"
}

provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project = local.gcp_project_name
  region  = "us-central1"
}
