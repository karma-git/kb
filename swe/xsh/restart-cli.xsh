#!/usr/bin/env xonsh
# PYTHON_ARGCOMPLETE_OK
import argparse
import argcomplete
from argcomplete.completers import ChoicesCompleter

import json
import yaml
import os

# save all kubernetes contextes
with open(os.environ["KUBECONFIG"]) as y: contexts = tuple([ctx["name"] for ctx in yaml.safe_load(y)["contexts"]])

example_text = "Example: xonsh argo-restart-pods.xsh --context sandbox"
parser = argparse.ArgumentParser(description="Restart Argo CD workloads", epilog=example_text)
parser.add_argument('--context', required=True, help="Kubernetes contexts").completer=ChoicesCompleter((contexts))
parser.add_argument('-n', '--namespace', help="argocd namespace", default="argocd")
argcomplete.autocomplete(parser)
args = parser.parse_args()

k_all: str = $(kubectl --context @(args.context) -n @(args.namespace) get all --output json)
k_all: dict = json.loads(k_all)["items"]

for obj in k_all:
  if obj["kind"] in ["Deployment", "StatefulSet"]:
    kubectl --context @(args.context) --namespace @(args.namespace) \
    rollout restart @(obj["kind"].lower()) @(obj["metadata"]["name"]) -o name
