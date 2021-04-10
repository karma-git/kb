# Tutorial summary
In this example you will learn how to deploy your website via virtualbox, vagrant, and ansible.
Please install these tools.
# Bridged host interface
In my case int name is `en0: Wi-Fi (AirPort)`.
Your option is check your interfaces name yourself in virtualbox gui or left host_bridge_int as an empty string:
```
$ grep host_bridge_int Vagrantfile | head -n2
# host_bridge_int = "en0: Wi-Fi (AirPort)"
host_bridge_int = ""
```
Then can do `$ vagrant up` and you'll see interfaces names during installation:
```
$ vagrant up
...
==> ubuntu: Specific bridge '' not found. You may be asked to specify
==> ubuntu: which network to bridge to.
==> ubuntu: Available bridged network interfaces:
1) en0: Wi-Fi (AirPort)
2) en1: Thunderbolt 1
3) en2: Thunderbolt 2
4) bridge0
5) p2p0
6) awdl0
7) llw0
8) en4: USB 10/100/1000 LAN
==> ubuntu: When choosing an interface, it is usually the one that is
==> ubuntu: being used to connect to the internet.
==> ubuntu:
    ubuntu: Which interface should the network bridge to?     # < -- You can choose from the list or edit Vagrantfile and rerun
```

# Create VMs
**Create** create machines via `$ vagrant up`

During provisioning you will see machines ip-addresses:
```
...
==> redhat: Running provisioner: shell...
    redhat: Running: inline script
    redhat: bridged int mac-address is <08:00:27:d0:90:fa>
    redhat: bridged int ip-address is <192.168.1.6>
```
Or you can login to machines via `$ vagrant ssh ubuntu` or `$ vagrant ssh redhat` and check it there.

You have to add them into `hosts.txt` file like in the example bellow:
```
$ cat hosts.txt
[example]
ubuntu ansible_host=192.168.1.3
redhat ansible_host=192.168.1.6
```
# Ansible ping-pong
Try to check VMs availability:
```
$ ansible example -m ping
ubuntu | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
redhat | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
# Play a Game
```
$ ansible-playbook playbook_example.yml

PLAY [Install Apache and load web-site] **************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [ubuntu]
ok: [redhat]

TASK [deploy_apache_web : Install Apache Web Server for RedHat] **************************************************************************
skipping: [ubuntu]
changed: [redhat]

TASK [deploy_apache_web : Start web Server service for RedHat] ***************************************************************************
skipping: [ubuntu]
changed: [redhat]

TASK [deploy_apache_web : Install Apache Web Server for Debian] **************************************************************************
skipping: [redhat]
changed: [ubuntu]

TASK [deploy_apache_web : Start web Server service for Debian] ***************************************************************************
skipping: [redhat]
ok: [ubuntu]

TASK [deploy_apache_web : Generate < index.html >] ***************************************************************************************
changed: [ubuntu]
changed: [redhat]

TASK [deploy_apache_web : Copy styles and scripts for index Page] ************************************************************************
changed: [ubuntu] => (item=script.js)
changed: [redhat] => (item=script.js)
changed: [ubuntu] => (item=style.css)
changed: [redhat] => (item=style.css)

RUNNING HANDLER [deploy_apache_web : Restart Apache RedHat] ******************************************************************************
skipping: [ubuntu]
changed: [redhat]

RUNNING HANDLER [deploy_apache_web : Restart Apache Debian] ******************************************************************************
skipping: [redhat]
changed: [ubuntu]

PLAY RECAP *******************************************************************************************************************************
redhat                     : ok=6    changed=5    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
ubuntu                     : ok=6    changed=4    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
```
# Check your website
After completing the game add your IP address into a browser's address line and you will see this:
![deployed](/vagrant_ansible/successfully_deployed.png)
