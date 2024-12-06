resource "google_storage_bucket" "terraform-backend-bucket" {
  name          = var.terraform_backend_bucket_name
  location      = "US" 
  storage_class = "STANDARD"
}
