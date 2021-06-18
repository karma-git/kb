# Example: run nginx website on ec2 instance
!Note: you should store aws credentials somewhere (`~/.aws/credentials` or environment variables)
### clone repo and move to folder
`$ https://github.com/karma-git/DevOps-Exploring.git && cd terraform/DevOps-Exploring/terraform/ec2-nginx`
### init
`$ terraform init`
### create resourse
`$ terraform apply`
---
### Check website in public network
```
Outputs:
...
webserver_public_ip = "18.153.0.162"
...
```
Not you can access to website via browser / curl.
!Note: When terraform returns outputs - site doesn't deployed yet. It takes up to ~30 seconds. 
