import os.path
import logging
import yaml
# ref: https://www.zabbix.com/documentation/current/en/manual/api
from pyzabbix import ZabbixAPI, ZabbixAPIException

HOST = "Zabbix server"  # default zabbix server hostname

logging.basicConfig(level=logging.INFO)


def get_config(relative_path: str = os.path.dirname(__file__) + '/../config.yml' ) -> dict:
    try:
        with open(relative_path, "r") as stream:
            config = yaml.safe_load(stream)
    except FileNotFoundError:
        logging.exception("Please make sure that you running script from the directory with script and config")
    except yaml.YAMLError as e:
        logging.exception(f"Looks like yaml invalid -> {e}")
    else:
        return config


def get_host_and_interface_id(zabbix_api: ZabbixAPI, host_name: str = HOST) -> tuple:
    host_object = zabbix_api.host.get(filter={"host": host_name, "name": host_name})
    host_id = host_object[0]["hostid"]
    host_interface_object = zabbix_api.hostinterface.get(hostids=host_id)
    host_interface_id = host_interface_object[0]["interfaceid"]
    logging.debug(f"host=<{HOST}>, has id=<{host_id}>, interface_id={host_interface_id}")
    return host_id, host_interface_id


def create_task_item(zabbix_api: ZabbixAPI, host_id: str, interface_id: str, identificator: int) -> None:
    try:
        zabbix_api.item.create(
            delay="1m",
            hostid=host_id,
            interfaceid=interface_id,
            key_=f"metric{identificator}",
            name=f"important_metric[metric{identificator}]",
            type=21,       # Script
            value_type=3,  # numeric unsigned
            params="return Math.floor(Math.random() * 100);",
            timeout="5s",
            tags=[{"tag": "Project", "value": "observability"}],
            description="the item generates random integer in range(0, 100)",
        )
    except ZabbixAPI:
        logging.exception("Exception occurred")
    else:
        logging.info(f"item with identificator=<{identificator}> has just been created")


def create_task_trigger(zabbix_api: ZabbixAPI, identificator: int):
    try:
        zabbix_api.trigger.create(
            description=f"metric{identificator}-trigger",
            expression=f"last(/{HOST}/metric{identificator})>95",
            comments="It will be triggered if the last metric value is higher than 95",
            priority=5,  # severity: disaster
            tags=[{"tag": "Project", "value": "observability"}],
        )
    except ZabbixAPI:
        logging.exception("Exception occurred")
    else:
        logging.info(f"trigger with identificator=<{identificator}> has just been created")


def main(url: str, login: str, passowrd: str, host: str) -> None:
    zapi = ZabbixAPI(url)
    zapi.login(login, passowrd)
    logging.info(zapi.api_version())

    host_id, int_id = get_host_and_interface_id(zapi, host)
    for i in range(1, 4):
        create_task_item(zapi, host_id, int_id, i)
        create_task_trigger(zapi, i)

if __name__ == "__main__":
    conf = get_config().get('zabbix')
    main(
        url=conf['url'],
        login=conf['login'],
        passowrd=conf['password'],
        host=conf['host'],
    )
