import uvicorn
from fastapi import FastAPI

import typing as t
import json

app = FastAPI()


@app.get("/restart-pods/{context}")
async def restart_pods(context: str, namespace: str = "argocd"):
    """
    Перезагрузка (`kubectl rollout restart`) deploy,sts в выбранном namespace-е
    """
    k_all: str = $(kubectl --context @(context) -n @(namespace) get all --output json)
    k_all: dict = json.loads(k_all)["items"]

    result = list()

    for obj in k_all:
      if obj["kind"] in ["Deployment", "StatefulSet"]:
        restarted = $(kubectl --context @(context) --namespace @(namespace) \
        rollout restart @(obj["kind"].lower()) @(obj["metadata"]["name"]) -o name).strip()
        result.append(restarted)
    return result


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
