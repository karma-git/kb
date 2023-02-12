---
title: "2 - Linux User no shell"
tags:
  - kodekloud-engineer-sysadmin
comments: true
---

```shell
thor@jump_host ~$ ssh tony@stapp01
[tony@stapp01 ~]$ sudo -i
# check current tz
[root@stapp01 ~]# adduser backup -s /sbin/nologin/
# create symlink
[root@stapp01 ~]# id backup; cat /etc/passwd | grep backup
```
