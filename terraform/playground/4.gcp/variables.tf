variable "gcp_creds_path" {
  type = string
  // https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials
  description = "path to JSON key file, witch allow you to make API calls"
}

// $ gcloud projects list
variable "project_id" {}

// https://cloud.google.com/compute/docs/regions-zones
variable "region" {
  type    = string
  default = "europe-central2"
}
