import paramiko
import os
from loguru import logger
from typing import NoReturn

COMMANDS = ["uname -a",
            "uptime -s",
            ]


def ssh(hostname: str, commands: list, **kwargs: dict) -> NoReturn:
    # Create ssh client instance
    client = paramiko.SSHClient()

    # Key Management

    # add from file if pkey specified in config else load system key
    if kwargs.get('pkey'):

        if os.environ.get('pk_pw'):
            key = paramiko.RSAKey.from_private_key_file(filename=kwargs['pkey'], password=os.environ['pk_pw'])
        else:
            key = paramiko.RSAKey.from_private_key_file(filename=kwargs['pkey'])

        kwargs.update({'pkey': key})
    # ---
    else:
        client.load_system_host_keys()  # add from system keys (ssh-add <pk>, eval $(ssh-agent))

    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())  # auto add to know host

    try:
        # see connect method, main params are: hostname, port, username, password
        client.connect(hostname=hostname, **kwargs)
    except Exception as e:
        logger.info("Hostname=({}), config=({})", hostname, kwargs)
        logger.error("Error=({}), description=({})", e.__class__.__name__, e)
    else:
        bs = lambda b: str(b, encoding='utf-8')
        for command in commands:
            logger.info("Executing command {}", command)
            stdin, stdout, stderr = client.exec_command(command)
            out = bs(stdout.read())
            logger.trace("stdout {}", out)
            err = bs(stderr.read())
            logger.trace("stderr {}", err)
            print(out, err, sep='\n---\n') if err else print(out)
    finally:
        client.close()


def vagrant_ssh():
    """
    $ vagrant ssh-config
    Host default
    HostName 127.0.0.1
    User vagrant
    Port 2222
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no
    IdentityFile /Users/me/vagrant/ubuntu1804/.vagrant/machines/default/virtualbox/private_key
    IdentitiesOnly yes
    LogLevel FATAL

    ---

    $ ssh -p 2222 -i $vagrant_pk vagrant@127.0.0.1 "uptime -s"
    2021-05-28 21:45:02
    """
    config = {
        "port": 2222,
        "username": "vagrant",
        "pkey": "/Users/me/vagrant/ubuntu1804/.vagrant/machines/default/virtualbox/private_key"
    }
    h = '127.0.0.1'
    ssh(h, COMMANDS, **config)


def aws_ec2_ssh():
    config = {
        "username": "ec2-user",
        "pkey": "/Users/ah/.ssh/aws-fr-pk.cer",
        "timeout": 2.5
    }

    h = 'ec2-18-198-188-136.eu-central-1.compute.amazonaws.com'
    ssh(h, COMMANDS, **config)


def main():
    vagrant_ssh()
    aws_ec2_ssh()


if __name__ == '__main__':
    main()
