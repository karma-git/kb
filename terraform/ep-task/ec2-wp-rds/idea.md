```php
# files/wp_config.php.tpl

define( 'DB_NAME', '${aws_rds.mydb.dbname}' );
define( 'DB_USER', '${aws_rds.mydb.user}' );
define( 'DB_PASSWORD', '${aws_rds.mydb.password}' );
define( 'DB_HOST', '${aws_rds.mydb.endpoint}' );
```

```terraform
# instance.tf

resource "local_file" "wp_config" {
  path = "files/wp_config.php"
  content = templatefile("files/wp_config.php.tpl", { ... })
}

resource "aws_instance" "web" {
    # ...
    
    provision "local-exec" {
    command = "ansible-playbook -i {self.private_ip}, ansible/playbook.yml"
  }
}
```

```yaml
# ansible/playbook.yml

---

- name: Install nginx
  hosts: all
  tasks:
    - name: ...
    

- name: Install PHP
  hosts: all
  tasks:
    - name: ...


- name: Install Wordpress
  hosts: all
  tasks:
    - name: ...
    - name: Deploy config
      copy:
        src: files/wp-config.php
        dest: /var/www/.../wp-config.php
```
