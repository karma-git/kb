variable "version" {
  type    = string
  default = ""
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "vagrant" "karma-linux" {
  add_force    = true
  communicator = "ssh"
  provider     = "virtualbox"
  source_path  = "ubuntu/focal64"
}

build {
  sources = ["source.vagrant.karma-linux"]

  provisioner "ansible" {
    playbook_file = "./ansible/packer-playbook.yml"
    ansible_env_vars = [
      "ANSIBLE_ROLES_PATH=./../../../ansible/roles.galaxy:./../../../ansible/roles",
      "ANSIBLE_REMOTE_USER=ubuntu",
    ]
    galaxy_file = "./../../../ansible/roles.galaxy/requirements.yml"
    roles_path  = "./../../../ansible/roles.galaxy"
  }
}

// TODO: vagrant-cloud postprocess
