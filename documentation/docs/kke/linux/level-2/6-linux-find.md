---
title: "6 - Linux Find Command"
tags:
  - kodekloud-engineer-sysadmin
comments: true
---

## Task


During a routine security audit, the team identified an issue on the Nautilus App Server. Some malicious content was identified within the website code. After digging into the issue they found that there might be more infected files. Before doing a cleanup they would like to find all similar files and copy them to a safe location for further investigation. Accomplish the task as per the following requirements:



a. On App Server 3 at location /var/www/html/ecommerce find out all files (not directories) having .php extension.


b. Copy all those files along with their parent directory structure to location /ecommerce on same server.


c. Please make sure not to copy the entire /var/www/html/ecommerce directory content.

CheckCompleteIncompleteTry


## Solution

```shell
thor@jump_host ~$ ssh banner@stapp03
[banner@stapp03 ~]$ sudo -i
[root@stapp03 ~]# find /var/www/html/ecommerce -type f -name '*.php' -exec cp --parents {} /ecommerce \;
[root@stapp03 ~]# ls /ecommerce
var
```

Error:
```
- Either no files are copied at all or some of them are missing on App Server 1
ERROR find.py - AssertionError: - Either no files are copied at all or some o...
```
