from pyzabbix import ZabbixAPI

# ref: https://www.zabbix.com/documentation/current/en/manual/api

zapi = ZabbixAPI("http://127.0.0.1:8080/")
zapi.login("Admin", "zabbix")

HOST = "Zabbix server"

ITEM_TEMPLATE = {
    # ref: https://www.zabbix.com/documentation/current/en/manual/api/reference/item/object#host
    "delay": "1m",
    "hostid": "",
    "interfaceid": "",
    "key_": "mX",
    "name": "important_metrics[metricX]",
    "type": 21,  # Script
    "value_type": 3,  # numeric unsigned
    "params": "return Math.floor(Math.random() * 100);",
    "timeout": "5s",
    "tags": [{"tag": "Project", "value": ""}],
    "description": "the item generates random integer in range(0, 100)",
}

TRIGGER_TEMPLATE = {
    # ref: https://www.zabbix.com/documentation/current/en/manual/api/reference/trigger/object#trigger
    "description": "mX-trigger",
    "expression": f"last(/{HOST}/mX)>95",
    "comments": "I guess what it will resolve itself",
    "priority": 5,  # severity: disaster
    "tags": [{"tag": "Project", "value": ""}],
}


def get_host_interface_ids(host_name: str = HOST) -> tuple:
    host_object = zapi.host.get(filter={"host": host_name, "name": host_name})
    host_id = host_object[0]["hostid"]
    host_interface_object = zapi.hostinterface.get(hostids=host_id)
    host_interface_id = host_interface_object[0]["interfaceid"]
    return host_id, host_interface_id


def create_item():
    pass


def create_trigger():
    pass


def main(host: str = HOST) -> None:
    host_id, int_id = get_host_interface_ids()
    ITEM_TEMPLATE.update({"hostid": host_id, "interfaceid": int_id})
    for i in range(1, 4):
        z_key = f"important_metrics[metric{i}]"
        ITEM_TEMPLATE.update({"key_": f"m{i}", "name": z_key})
        zapi.item.create(**ITEM_TEMPLATE)

        TRIGGER_TEMPLATE.update({"expression": f"last(/{host}/m{i})>95"})
        zapi.trigger.create(**TRIGGER_TEMPLATE)


if __name__ == "__main__":
    main()
