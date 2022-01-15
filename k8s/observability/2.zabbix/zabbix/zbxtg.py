from zabbix import get_config

conf = get_config()

tg_key = conf['telegram']['token']
zbx_tg_signature = conf['telegram']['signature']
zbx_tg_tmp_dir = conf['telegram']['tmp-dir']

zbx_server = conf['zabbix']['url']
zbx_api_user = conf['zabbix']['login']
zbx_api_pass = conf['zabbix']['password']
zbx_server_version = conf['zabbix']['api-version']

emoji_map = {
 "OK": "✅",
 "Not classified": "❕",
 "Information": "ℹ",
 "Warning": "⚠",
 "Average": "❗",
 "High": "❌",
 "Disaster": "🔥"
}
