import argparse
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

# Clear current logger
logger.remove(0)
# logger.add(sys.stderr, level='TRACE')
logger.add(sys.stderr, level='ERROR')


def ec2_obj(key: str, secret: str, region: str):
    """
    :return: <class 'boto3.resources.factory.ec2.Instance'>
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
    ansible_inventory = input('file path for ansible_hosts: ')

    config['aws'] = {
        'aws_access_key_id': access_key,
        'aws_secret_access_key': secret,
        'region_name': region,
    }
    config['config'] = {
        'ansible_inventory': ansible_inventory,
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
              config.get('config', 'ansible_inventory')
              )
    return params


def launch_ec2_instance(ec2, json_path: str = False, user_args: dict = False, region: str = False) -> tuple:
    """
    :param ec2: <class 'boto3.resources.factory.ec2.Instance'>
    :param json_path:
    :param user_args:
    :param region:
    :return:
    """
    logger.debug('Args: ec2={},{}\n; json_path={},{}\n; user_args={},{}\n; region={},{}',
                 ec2, type(ec2), json_path, type(json_path), user_args, type(user_args), region, type(region))

    # if json != False and user_args != False:
    #     logger.critical("Only one option for describing ec2 instance is allowed")
    #     raise ParamsConflict

    if json_path:
        with open(json_path) as jsonfile:
            params = json.load(jsonfile)
            instances = ec2.create_instances(**params)

    elif user_args and region:
        choice = lambda user_arg, default_arg: user_args.get(user_arg) if user_args.get(
            user_arg) is not None else default_arg
        # TODO: choices for argparse!
        try:
            hostname = user_args['TagSpecifications'][0]['Tags'][0]['Value']
        except (ValueError, TypeError) as error:
            logger.warning("Looks like you did not specified hostname error => {}", error)
        finally:
            hostname = f'{region}-node_{str(random.choice(range(1, 10)))}' if not 'hostname' in locals() else \
                user_args['TagSpecifications'][0]['Tags'][0]['Value']

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
                         "Value": hostname}
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
    finally:
        add_to_inv = f"ansible_host={ip4}\n" if not 'alias' in locals() else f"{alias} ansible_host={ip4}\n"

        with open(hosts_file_path, 'a') as ansible_hosts_file:
            ansible_hosts_file.write(add_to_inv)


def worker(iac_filepath: str = False, cli_config: dict = False, add_to_inventory: bool = False) -> NoReturn:
    key, secret, region, ansible_hosts = read_config()

    ec2 = ec2_obj(key, secret, region)
    if iac_filepath:
        ec2_dict, ip4 = launch_ec2_instance(ec2, json_path=iac_filepath, region=region)
    elif cli_config:
        ec2_dict, ip4 = launch_ec2_instance(ec2, user_args=cli_config, region=region)
    # END CONDITION and print IPV4
    print(ip4)

    if add_to_inventory:
        add_ec2_to_ansible_hosts(ec2_dict, ip4, ansible_hosts)


def main():
    parser = argparse.ArgumentParser(description="A CLI for provisioning ec2 instances on AWS",
                                     formatter_class=argparse.RawTextHelpFormatter)

    # Management Flags
    parser.add_argument('-r', '--region', help='Change current region')
    parser.add_argument('-u', '--update_config', help='update aws config')

    # Infrastructure as a Code from a json file
    parser.add_argument('--iac', help='filepath for IaC in a json file', default=False)

    # Configure EC2 instance via CLI params
    parser.add_argument('-z', '--availability_zone', help='Availability Zone', default=False)
    parser.add_argument('-i', '--instance_type', help='Instance type', choices=['t2.micro'], default='t2.micro')
    parser.add_argument('-g', '--image_id', help='OS type for provisioning', choices=['ami-043097594a7df80ec'],
                        default='ami-043097594a7df80ec')
    parser.add_argument('-k', '--key_name', help='key-name on aws', default=False)
    parser.add_argument('-s', '--security_group', help='Access for the ec2', default='sg-3ef6eb4d')
    parser.add_argument('-n', '--hostname', help='Tag -> Name -> <Value>', default='False')

    # ON/OFF adding a record to ansible inventory file
    parser.add_argument('-a', '--ansible_inventory', help='save ip4 to ansible inventory file', action='store_true',
                        default=False)

    # TODO: DEBUG FLAGS HERE

    args = parser.parse_args()
    logger.debug("argparse namespace: {}", args)

    if args.region or args.update_config:
        create_config() if args.update_config else update_region() if args.region else logger.critical("Something is "
                                                                                                       "wrong")
        logger.info('AWS config has been updated, please relaunch cli!')
        sys.exit('Exit')

    if args.iac:
        worker(iac_filepath=args.iac) if not args.ansible_inventory else worker(iac_filepath=args.iac,
                                                                                add_to_inventory=True)
    elif not args.iac:
        cli_iac_config = {
            "ImageId": args.image_id,
            "InstanceType": args.instance_type,
            # TODO from flag
            "MinCount": 1,
            "MaxCount": 1,
            "SecurityGroupIds": [args.security_group],
            "Placement": {
                "AvailabilityZone": args.availability_zone,
            },
            "KeyName": args.key_name,
            "TagSpecifications": [{
                "ResourceType": "instance",
                "Tags": [
                    {
                        "Key": "Name",
                        "Value": args.hostname.replace(' ', '_')
                    },
                ]
            }]
        }
        worker(cli_config=cli_iac_config) if not args.ansible_inventory else worker(cli_config=cli_iac_config,
                                                                                    add_to_inventory=True)


if __name__ == '__main__':
    main()
