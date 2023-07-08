import argparse
import json

import asyncio

from async_k8s import k8sAsyncTask
from tasks import get_cm_aws_auth


def pj(data: dict):
    print(json.dumps(data, indent=4))


async def main():
    tasks = [
        'get_cm_aws_auth',
    ]

    example_text = """
    Example: python3 main.py --task get_cm_aws_auth --context $(kubectl config view | yq e '[.contexts[].name] | join(",")' -) | jq
    """
    parser = argparse.ArgumentParser(description="run k8s task on clusters", epilog=example_text)
    parser.add_argument("-t", "--task", help="choose task", choices=tasks)
    parser.add_argument("-ctx", "--context", help="comma separated contexts list")
    args = parser.parse_args()

    task = globals()[args.task]
    context = args.context.split(",")
    k = k8sAsyncTask(context, task)
    r = await k.tasks_results()
    return r


if __name__ == "__main__":
    r =  asyncio.run(main())
    pj(r)
