# DevOps Environment

> Ubuntu 20.04 (focal) with a lot of useful DevOps stuff on board (docker, kubectl, python,  go and etc.)

[![asciicast](https://asciinema.org/a/58jLHlUsCZA63uGjIClQcX5r0.svg)](https://asciinema.org/a/58jLHlUsCZA63uGjIClQcX5r0)

- [Packer](https://github.com/karma-git/playground/tree/master/environment/vagrant/build)
- [Ansible](https://github.com/karma-git/playground/tree/master/ansible)
- [Vagrant Cloud](https://app.vagrantup.com/karma-kit)
- [Vagrantfile examples](https://github.com/karma-git/playground/tree/master/environment/vagrant/examples)


## Guest Additions

> [6.4. Installing the VirtualBox Guest Additions](https://docs.oracle.com/cd/E36500_01/E36502/html/qs-guest-additions.html)

You can try my [`Vagrantfile`](./Vagrantfile)

---

Also this may work in your case (reboot required):

```shell
vagrant plugin uninstall vagrant-vbguest
vagrant destroy -f
vagrant up
vagrant plugin install vagrant-vbguest
vagrant vbguest --do install
```

---

Ansible role [petermosmans.virtualbox-guest](https://github.com/PeterMosmans/ansible-role-virtualbox-guest) could be also useful here.
