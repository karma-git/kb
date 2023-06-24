macos-env
=========

Роль для установки различного софта и конфигураций на локальный macos компьютер

Requirements & Dependencies
------------

Для работы brew модуля
```shell
ansible-galaxy collection install community.general
```

Role Variables
--------------

```yaml
brew_formulae_task_enabled: true
brew_formulae_install_list:
  - jwt-cli
  - helm
brew_formulae_exclude_list: []
# cask is a installation of gui application
brew_cask_task_enabled: true
brew_cask_install_list:
  - discord
  - lens
brew_cask_exclude_list: []

# NOTE: pip - python package manager
pip_task_enabled: true
pip_install_list:
  # linters
  - ansible-lint
  - black
  - yamllint
pip_exclude_list: []

dotfiles_task_enabled: true
```

Example Playbook
----------------

```yaml
---

- hosts: localhost
  gather_facts: true

  vars:
    brew_formulae_task_enabled: false
    brew_cask_task_enabled: false
    pip_task_enabled: false
    dotfiles_task_enabled: true

  roles:
    - role: ../roles/macos-env  # путь до роли
```

License
-------

Unlicense

Author Information
------------------

Andrew Horbach [https://github.com/karma-git](https://github.com/karma-git)
