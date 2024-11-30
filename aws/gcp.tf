resource "google_storage_bucket" "some_gcp_bucket" {
  name                        = "some-gcp-bucket"
  location                    = "US"
  force_destroy               = true
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}

resource "google_iam_workload_identity_pool" "some_pool" {
  workload_identity_pool_id = local.gcp_pool_id
  display_name              = "the pool"
}

resource "google_iam_workload_identity_pool_provider" "some_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.some_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = local.gcp_provider_id
  display_name                       = "some provider"
  disabled                           = false

  aws {
    account_id = local.aws_account_id
  }

  attribute_mapping = {
    "google.subject"     = "assertion.arn"
    "attribute.account"  = "assertion.account"
  }

  attribute_condition = "attribute.account == '${local.aws_account_id}'"
}

resource "google_storage_bucket_iam_binding" "some_bucket_binding" {
  bucket = google_storage_bucket.some_gcp_bucket.name
  role   = "roles/storage.admin"

  members = [
    "principal://iam.googleapis.com/projects/${local.gcp_project_number}/locations/global/workloadIdentityPools/${local.gcp_pool_id}/subject/arn:aws:sts::${local.aws_account_id}:assumed-role/${aws_iam_role.some_aws_role.name}/${aws_instance.some_aws_instance.id}"
  ]
}
