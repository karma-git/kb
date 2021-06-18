#!/bin/bash
amazon-linux-extras install epel
yum -y install nginx

systemctl start nginx
systemctl enable nginx

mkdir -p /var/www/html/default
chown -R nginx:nginx /var/www/html/default

sed -i 's/\/usr\/share\/nginx\/html/\/var\/www\/html\/default/g' /etc/nginx/nginx.conf

fileid=1UwjD7TxYOWUd-UVLlWXlU6OjJX9ra47I
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id='$fileid -O /var/www/html/default/website.zip
unzip /var/www/html/default/website.zip -d /var/www/html/default/

systemctl restart nginx