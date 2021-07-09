#!/bin/bash
yum install -y httpd php php-mysql
amazon-linux-extras install -y php7.3
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -r wordpress/* /var/www/html/
sed -i 's/database_name_here/${db_name}/g' /var/www/html/wp-config.php
sed -i 's/username_here/${db_user}/g' /var/www/html/wp-config.php
sed -i 's/password_here/${db_pw}/g' /var/www/html/wp-config.php
sed -i 's/localhost/${db_ep}/g' /var/www/html/wp-config.php
systemctl enable httpd
sudo systemctl start httpd