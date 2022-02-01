andrewhorbach.devops-env  # TBD
=========

A role that installs a lot of useful tools for a DevOps Engineer daily routine, such as:

- zsh + ohmyzsh + starship
- docker engine, docker-compose
- ansible, awscli, jq, kubectl, helm, terraform
- some programming languages (go, nodejs, python)

Requirements
------------

See [meta/main.yml](meta/main.yml)

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

See [meta/main.yml](meta/main.yml)

Example Playbook
----------------

```yml
- hosts: all
  roles:
    - andrewhorbach.devops-env  # TBD
```

License
-------

Unlicense

Author Information
------------------

Andrew Horbach <andrewhorbach@gmail.com>
