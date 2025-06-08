locals {
  // $ ssh-keygen -t ed25519 -f ~/.ssh/ansible -C ansible
  ssh_keys = [
    {
      user             = "ansible"
      private_key_path = "~/.ssh/ansible"
      public_key_path  = "~/.ssh/ansible.pub"
    },
  ]
  // ansible alias
  ssh = local.ssh_keys[0]

  author = "ahorbach"
}
