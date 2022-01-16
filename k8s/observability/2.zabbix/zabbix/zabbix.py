import os.path
import logging
import yaml

# ref: https://www.zabbix.com/documentation/current/en/manual/api
from pyzabbix import ZabbixAPI, ZabbixAPIException

HOST = "Zabbix server"  # default zabbix server hostname

logging.basicConfig(level=logging.INFO)


def get_config(relative_path: str = os.path.dirname(__file__) + "/../config.yml") -> dict:
    try:
        with open("config.yml", "r") as stream:
            config = yaml.safe_load(stream)
    except FileNotFoundError:
        try:
            with open(relative_path, "r") as stream:
                config = yaml.safe_load(stream)
        except FileNotFoundError:
            logging.exception("Could'nt find config")
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
            type=21,  # Script
            value_type=3,  # numeric unsigned
            params="return Math.floor(Math.random() * 100);",
            timeout="5s",
            tags=[{"tag": "Project", "value": "observability"}],
            description="the item generates random integer in range(0, 100)",
        )
    except ZabbixAPIException:
        logging.exception("Exception occurred")
    else:
        logging.info(f"item with identificator=<{identificator}> has just been created")


def create_task_trigger(zabbix_api: ZabbixAPI, identificator: int) -> None:
    try:
        zabbix_api.trigger.create(
            description=f"metric{identificator}-trigger",
            expression=f"last(/{HOST}/metric{identificator})>95",
            comments="It will be triggered if the last metric value is higher than 95",
            priority=5,  # severity: disaster
            tags=[{"tag": "Project", "value": "observability"}],
        )
    except ZabbixAPIException:
        logging.exception("Exception occurred")
    else:
        logging.info(f"trigger with identificator=<{identificator}> has just been created")


def get_tg_media_type_id(zabbix_api: ZabbixAPI) -> str:
    try:
        media_type_obj = zabbix_api.mediatype.get(
            name="Telegram",  # standard media type with js script
            type=1,  # Webhook
        )
    except ZabbixAPIException:
        logging.exception("Exception occurred")
    else:
        media_type_tg = media_type_obj[14]
        try:
            assert media_type_tg["name"] == "Telegram"
        except AssertionError:
            for i in media_type_obj:
                if i['name'] == "Telegram":
                    return i["mediatypeid"]
        else:
            return media_type_tg["mediatypeid"]


def update_tg_media_type(zabbix_api: ZabbixAPI, tg_token: str, media_type_id: str) -> None:
    """ "
    We'd like to use standard telegram script
    ref: https://git.zabbix.com/projects/ZBX/repos/zabbix/browse/templates/media/telegram
    """
    try:
        media_type_id = zabbix_api.mediatype.update(
            mediatypeid=media_type_id,
            name="Telegram",  # standard media type with js script
            type=4,  # Webhook
            passwd=tg_token,
        )
    except ZabbixAPIException:
        logging.exception("Exception occurred")
    else:
        logging.info(f"Telegram media type has been updated")
        return media_type_id


def get_user_id(zabbix_api: ZabbixAPI, user: str) -> str:
    try:
        user_obj = zabbix_api.user.get(
            username=user,
        )
    except ZabbixAPIException:
        logging.exception("Exception occurred")
    else:
        assert user_obj[0]["username"] == "Admin"
        return user_obj[0]["userid"]


def add_tg_id_to_user_media(zabbix_api: ZabbixAPI, user: str, tg_id: str, user_id: str, media_type_id: str):
    try:
        zabbix_api.user.update(
            alias=user,  # standard media type with js script
            userid=user_id,
            user_medias=[{"mediatypeid": media_type_id, "sendto": tg_id}],
        )
    except ZabbixAPIException:
        logging.exception("Exception occurred")
    else:
        logging.info(f"Media type has been added to {user}")


def main(url: str, login: str, passowrd: str, host: str, tg_id: str, tg_token: str) -> None:
    zapi = ZabbixAPI(url)
    zapi.login(login, passowrd)
    logging.info(zapi.api_version())

    media_type_id = get_tg_media_type_id(zapi)
    # update_tg_media_type(zapi, tg_token, media_type_id)

    user_id = get_user_id(zapi, login)
    # add_tg_id_to_user_media(zapi, login, tg_id, user_id, media_type_id)
    # FIXME: 'Error -32602: Invalid params., Invalid parameter "/1/user_medias/1/sendto": an array is expected.', -32602)

    host_id, int_id = get_host_and_interface_id(zapi, host)
    for i in range(1, 4):
        create_task_item(zapi, host_id, int_id, i)
        create_task_trigger(zapi, i)


if __name__ == "__main__":
    # TODO: add cls?
    conf = get_config()
    main(
        url=conf["zabbix"]["url"],
        login=conf["zabbix"]["login"],
        passowrd=conf["zabbix"]["password"],
        host=conf["zabbix"]["host"],
        tg_id=conf["telegram"]["id"],
        tg_token=conf["telegram"]["token"],
    )
