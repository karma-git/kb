# Config File
You should specify secrets and working region.

NOTE: 
- Availability Zones should be inside the region from this config.
- If you want to save alias and ip4 to ansible hosts file, you should provide filepath here
- config could be rewritten via -u flag
- you could update only region via -r flag
```
$ python ec2_launcher.py -k $key_name -n 'webserver from cli' -a -s 'sg-0eeb4b61babd1c003'
AWS Access Key ID: 
AWS Secret Access Key: 
region name: eu-central-1
file path for ansible_hosts: ~/.ansible_hosts.yml
```
# Launch via json IaC
```
$ python ec2_launcher.py --iac /Users/ah/repos/DevOps/github_repo/aws_boto3/fr-1.json -a
18.192.63.65
```
## IaC file example
JSON
```
{
   "ImageId":"ami-043097594a7df80ec",
   "InstanceType":"t2.micro",
   "MinCount":1,
   "MaxCount":1,
   "SecurityGroupIds":[
      "MY_CUSTOM_GROUP"
   ],
   "Placement":{
      "AvailabilityZone":"MY_AZ"
   },
   "KeyName":"KEY_NAME",
   "TagSpecifications":[{
      "ResourceType":"instance",
      "Tags":[
         {
            "Key":"Name",
            "Value":"ALIAS<->HOSTNAME"
         },
         {
            "Key":"Owner",
            "Value":"EMAIL"
         }
      ]
   }]
}
```

# Launch via CLI agrs
```
$ python ec2_launcher.py -k $key_name -n 'webserver from cli' -a -s $sg
3.120.40.113
```
# Ansible
### Invenotry
```
$ tail -n2 hosts.txt
fr-webserver ansible_host=18.192.63.65
webserver_from_cli ansible_host=3.120.40.113
```
### play role from
```
$ ansible-playbook playbook_deploy_site.yml --extra-vars "MYHOSTS=aws"

PLAY [Install Apache and load web-site] **********************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************************
ok: [fr-webserver]
ok: [webserver_from_cli]

TASK [deploy_apache_web : Install Apache Web Server for RedHat] **********************************************************************************************************
changed: [webserver_from_cli]
changed: [fr-webserver]

TASK [deploy_apache_web : Start web Server service for RedHat] ***********************************************************************************************************
changed: [webserver_from_cli]
changed: [fr-webserver]

TASK [deploy_apache_web : Install Apache Web Server for Debian] **********************************************************************************************************
skipping: [fr-webserver]
skipping: [webserver_from_cli]

TASK [deploy_apache_web : Start web Server service for Debian] ***********************************************************************************************************
skipping: [fr-webserver]
skipping: [webserver_from_cli]

TASK [deploy_apache_web : Generate < index.html >] ***********************************************************************************************************************
changed: [fr-webserver]
changed: [webserver_from_cli]

TASK [deploy_apache_web : Copy styles and scripts for index Page] ********************************************************************************************************
changed: [webserver_from_cli] => (item=script.js)
changed: [fr-webserver] => (item=script.js)
changed: [fr-webserver] => (item=style.css)
changed: [webserver_from_cli] => (item=style.css)

RUNNING HANDLER [deploy_apache_web : Restart Apache RedHat] **************************************************************************************************************
changed: [fr-webserver]
changed: [webserver_from_cli]

RUNNING HANDLER [deploy_apache_web : Restart Apache Debian] **************************************************************************************************************
skipping: [fr-webserver]
skipping: [webserver_from_cli]

PLAY RECAP ***************************************************************************************************************************************************************
fr-webserver               : ok=6    changed=5    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
webserver_from_cli         : ok=6    changed=5    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
```
### Result
After completing the game add your IP address into a browser's address line and you will see this: deployed
![deployed](/aws_boto3/ec2_deployment.png)

