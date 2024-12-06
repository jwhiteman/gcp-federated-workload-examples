resource "google_service_account" "gitlab-cd" {
  account_id   = "gitlab-cd"
  display_name = "Gitlab CD Service Account"
}

resource "google_project_iam_member" "project-owner" {
  project = var.project_name
  role    = "roles/owner"
  member  = google_service_account.gitlab-cd.member
}

resource "google_iam_workload_identity_pool" "cd-pool" {
  workload_identity_pool_id = var.pool_id
  display_name              = "CD Pool"
  description               = "Identity pool for CD"
}

resource "google_iam_workload_identity_pool_provider" "cd-provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.cd-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "gitlab-provider"

  attribute_mapping = {
    "google.subject"         = "assertion.sub"
    "attribute.project_id"   = "assertion.project_id"
    "attribute.namespace_id" = "assertion.namespace_id"
  }

  attribute_condition = "assertion.project_id == \"YOUR_GITLAB_PROJECT_ID\" && assertion.namespace_id == \"YOUR_GITLAB_NAMESPACE_ID\""

  oidc {
    issuer_uri = "https://gitlab.com"
  }
}

resource "google_service_account_iam_member" "service-account-assumer" {
  service_account_id = google_service_account.gitlab-cd.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${var.pool_id}/attribute.project_id/YOUR_GITLAB_PROJECT_ID"
}

