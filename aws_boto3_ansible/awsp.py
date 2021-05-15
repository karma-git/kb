import boto3
import os
import sys
import random
import json
from configparser import ConfigParser
from typing import NoReturn
from getpass import getpass
from loguru import logger
from exceptions import (ParamsConflict)


def ec2_obj(key: str, secret: str, region: str):
    """
    :return: ec2.ServiceResource
    """
    ec2 = boto3.resource('ec2',
                         aws_access_key_id=key,
                         aws_secret_access_key=secret,
                         region_name=region,
                         )
    logger.info('EC2.ServiceResource => (obj={}, type={}', ec2, type(ec2))
    return ec2


def create_config() -> NoReturn:
    """
    Create config file for EC2.ServiceResource
    """
    config = ConfigParser()
    access_key = getpass('AWS Access Key ID: ')
    secret = getpass('AWS Secret Access Key: ')
    region = input('region name: ')

    config['aws'] = {
        'aws_access_key_id': access_key,
        'aws_secret_access_key': secret,
        'region_name': region,
    }

    with open('config.ini', 'w') as configfile:
        config.write(configfile)


def update_region() -> NoReturn:
    region = input('region name: ')
    config = ConfigParser()
    config.read('config.ini')
    config.set('aws', 'region_name', region)
    with open('config.ini', 'w') as configfile:
        config.write(configfile)


def read_config() -> tuple:
    if not os.path.isfile('config.ini'):
        logger.warning('Config file is not exist, creating ...')
        logger.debug('ll result in the script directory {}', sys.argv[0], os.listdir())
        create_config()

    config = ConfigParser()
    config.read('config.ini')
    params = (config.get('aws', 'aws_access_key_id'),
              config.get('aws', 'aws_secret_access_key'),
              config.get('aws', 'region_name'),
              )
    return params


def launch_ec2_instance(ec2, json_path=False, user_args=False, region=False) -> tuple:
    if json and user_args:
        logger.critical("Only one option for describing ec2 instance is allowed")
        raise ParamsConflict

    if json_path:
        with open(json_path) as jsonfile:
            params = json.load(jsonfile)
            instances = ec2.create_instances(**params)

    elif user_args and region:
        choice = lambda user_arg, default_arg: user_args.get(user_arg) if user_args.get(
            user_arg) is not None else default_arg
        # TODO: choices for argparse!
        instances = ec2.create_instances(
            ImageId=choice('ImageId', 'ami-043097594a7df80ec'),  # Amazon Linux 2 by default
            InstanceType=choice('InstanceType', 't2.micro'),  # Free Tier
            MinCount=choice('MinCount', 1),
            MaxCount=choice('MaxCount', 1),
            SecurityGroupIds=choice('SecurityGroupIds', ['sg-3ef6eb4d']),  # sg-3ef6eb4d default security group on aws
            # Every region has min 2 AZ
            Placement={'AvailabilityZone': choice('AvailabilityZone', f"{region + random.choice(['a', 'b'])}")},
            KeyName=user_args['KeyName'] if user_args.get('KeyName') else logger.critical('KeyName is not selected!'),
            # Add only alias for ec2 instance
            TagSpecifications=[
                {
                    "ResourceType": "instance",
                    "Tags": [
                        {"Key": "Name",
                         "Value": choice('Name', random.choice(f"{region + '-node_' + random.choice(range(1, 10))}"))}
                    ]
                }
            ]
        )

    # END OF THE CONDITION
    instance = instances[0]
    instance.wait_until_running()
    instance.load()

    logger.debug("Instance info: (call => {}, type => {}",
                 instance, type(instance))

    ec2_instance_properties = {key: getattr(instance, key) for key in dir(instance)
                               if not key.startswith('_') and not callable(getattr(instance, key))}
    logger.debug("Instance info: {}", ec2_instance_properties)
    return ec2_instance_properties, instance.public_ip_address


def add_ec2_to_ansible_hosts(ec2_info: dict, ip4: str, hosts_file_path: str) -> NoReturn:
    try:
        alias = list(filter(lambda x: True if x['Key'] == 'Name' else False, ec2_info['tags']))[0]['Value']
    except (ValueError, TypeError) as error:
        logger.warning(error)
    else:
        add_to_inv = f"{alias} ansible_host={ip4}"
    finally:

        if not 'alias' in locals():
            add_to_inv = f"ansible_host={ip4}"

        with open(hosts_file_path, 'a') as ansible_hosts_file:
            ansible_hosts_file.write(add_to_inv)


def main() -> NoReturn:
    key, secret, region = read_config()

    ec2 = ec2_obj(key, secret, region)
    ec2_dict, ip4 = launch_ec2_instance(ec2, '/Users/ah/repos/DevOps/github_repo/aws_boto3_ansible/ec2_details.json')
    print(ip4)
    add_ec2_to_ansible_hosts(ec2_dict, ip4, '/Users/ah/infra/ansible/hosts.txt')


if __name__ == '__main__':
    main()
