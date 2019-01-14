terraform {
 backend "gcs" {
   bucket  = "khalyk-terraform-admin"
   prefix  = "terraform/state"
   project = "khalyk-terraform-admin"
 }
}
