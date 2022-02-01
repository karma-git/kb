variable "cloud-token" {
  type = string
}

locals {
  version = "1.0"
}

source "vagrant" "devops-env" {
  add_force            = true
  communicator         = "ssh"
  provider             = "virtualbox"
  source_path          = "ubuntu/focal64"
  output_dir           = "vagrant-output"
}

build {
  sources = ["source.vagrant.devops-env"]

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_ROLES_PATH=./../../../../ansible/roles.galaxy:./../../../ansible/roles",
      "ANSIBLE_REMOTE_USER=vagrant",
    ]
    galaxy_file = "./../../../../ansible/roles.galaxy/requirements.yml"
    roles_path  = "./../../../../ansible/roles.galaxy"
  }

  post-processors {

    post-processor "vagrant-cloud" {
      access_token        = var.cloud-token
      box_tag             = "karma-kit/focal64-devops"
      version             = local.version
      version_description = file("CHANGELOG.md")
      no_release          = false
    }
  }
}
