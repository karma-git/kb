### how to install roles?

- change variable inside `install_roles.yml`
- execute the following

```shell
ansible-galaxy roles install -r roles.galaxy/requirements.yml
export ANSIBLE_ROLES_PATH="$(pwd)/roles.galaxy:$(pwd)/roles"
ansible-playbook install_roles.yml -K
```
