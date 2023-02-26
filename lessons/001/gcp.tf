locals {
  project_id = "ahorbach" # var
  network    = "default"
}

// -------------------------------------------------------
// Provider

provider "google" {
  project = var.gcp_project_id
  region  = "europe-central2"
  zone    = "europe-central2-b"
}

// -------------------------------------------------------
// SSH keys, network settings

data "google_client_openid_userinfo" "ahorbach" {}

resource "google_os_login_ssh_public_key" "this" {
  project = var.gcp_project_id
  user    = data.google_client_openid_userinfo.ahorbach.email
  key     = file(local.ssh.public_key_path)
}

resource "google_service_account" "this" {
  account_id = "${var.gcp_project_id}-nginx"
}

resource "google_compute_firewall" "web" {
  name    = "web-access"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]

  target_service_accounts = [google_service_account.this.email]
}

// -------------------------------------------------------
// VM

resource "google_compute_instance" "this" {
  name         = "${local.author}-nginx"
  machine_type = "e2-micro"
  zone         = "europe-central2-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230213"
    }
  }

  network_interface {
    network = local.network
    access_config {}
  }

  service_account {
    email  = google_service_account.this.email
    scopes = ["cloud-platform"]
  }

  // creater users and put public keys
  metadata = {
    ssh-keys = join("\n", [for key in local.ssh_keys : "${key.user}:${file(key.public_key_path)}"])
  }

  provisioner "remote-exec" {
    inline = ["echo 'Waint until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh.user
      private_key = file(local.ssh.private_key_path)
      host = self.network_interface.0.access_config.0.nat_ip
    }
  }

  provisioner "local-exec" {
    command = <<EOF
        ansible-playbook \
          --inventory '${self.network_interface.0.access_config.0.nat_ip},' \
          --private-key ${local.ssh.private_key_path} \
          --user ${local.ssh.user} \
          ./playbook.yml
        EOF
  }
}

output "gcp_nginx" {
  value = google_compute_instance.this.network_interface.0.access_config.0.nat_ip
}
