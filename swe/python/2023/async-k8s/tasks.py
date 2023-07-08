import yaml
from kubernetes_asyncio import client, config
from kubernetes_asyncio.client.api_client import ApiClient


async def get_cm_aws_auth(api):
    v1 = client.CoreV1Api(api)
    result = await v1.read_namespaced_config_map(name="aws-auth", namespace="kube-system")
    users = yaml.safe_load(result.data["mapUsers"])
    users_groups = [{"username": user["username"], "group": user["groups"]} for user in users]
    return users_groups
