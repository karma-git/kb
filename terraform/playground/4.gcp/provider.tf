// https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started
provider "google" {
  credentials = file(var.gcp_creds_path)
  project     = var.project_id
  region      = var.region
  zone        = "${var.region}${random_shuffle.zone.result[0]}"
}

resource "random_shuffle" "zone" {
  input        = ["-a", "-b", "-c"]
  result_count = 1
}
