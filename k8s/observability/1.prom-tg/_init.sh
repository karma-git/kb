#!/bin/bash

AWS_ECR_EXPORTER_ARGS="env.AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID},env.AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY},env.AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"
TG_RECEIVER_ARGS="env.TELEGRAM_ADMIN=${TELEGRAM_ADMIN},env.TELEGRAM_TOKEN=${TELEGRAM_TOKEN}"
NAMESPACE=prometheus-stack

#--- prom-stack
echo Installing prometheus stack...

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace $NAMESPACE \
  --create-namespace

arr=(
    $AWS_ACCESS_KEY_ID, 
    $AWS_SECRET_ACCESS_KEY, 
    $AWS_DEFAULT_REGION,
    $TELEGRAM_ADMIN,
    $TELEGRAM_TOKEN
    )

function validate_env {
    for el in arr
      do
        if [[ -z "$el" ]]; then
          echo "error, some variable is empty"
          exit 1
        else
          echo "env vars is okay, processing..."
        fi
      done
}

validate_env

echo "sleep for 60 sec during prom-stack installation"
sleep 60

#---aws-ecr-exporter
echo Installing aws-ecr-exporter...
helm upgrade --install aws-ecr-exporter ./.helm/aws-ecr-exporter \
  --set $AWS_ECR_EXPORTER_ARGS \
  --namespace $NAMESPACE

echo "sleep for 20 sec aws-ecr-exporter installation"
sleep 20

#---alertmanager-bot
echo Installing alertmanager-bot...
ALERTMANAGER_IP=$(
  kubectl get ep -n prometheus-stack \
  | egrep "^alertmanager-operated" \
  | egrep -m 1 -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]" \
  | head -n 1
)

export ALERTMANAGER_EP="--alertmanager.url=http://${ALERTMANAGER_IP}:9093"
# We can not to override just one arg from list via --set, let's use yq instead
yq e -i '.args[0] = strenv(ALERTMANAGER_EP)' ./.helm/alertmanager-bot/values.yaml

helm upgrade --install alertmanager-bot ./.helm/alertmanager-bot \
  --set $TG_RECEIVER_ARGS \
  --namespace $NAMESPACE

echo "sleep for 20 sec during alertmanager-bot installation"
sleep 20
echo "Got to your telegram bot and type /start"

#---Finalize
echo Updating prom stack...
export TG_WEBHOOK=http://$(
  kubectl get ep -n prometheus-stack \
  | grep alertmanager-bot \
  | awk '{print $2}'
)

yq e -i '.alertmanager.config.receivers[1].webhook_configs[0].url = strenv(TG_WEBHOOK)' prom-values.yaml

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace $NAMESPACE \
  --values=prom-values.yaml

echo Port-forwaring

kubectl port-forward service/prometheus-kube-prometheus-prometheus 9090:9090 -n $NAMESPACE &
kubectl port-forward service/alertmanager-operated 9093:9093 -n $NAMESPACE &
kubectl port-forward service/alertmanager-bot 8080:8080 -n $NAMESPACE &

sleep 15

echo Test-alert
curl \
--request POST \
--data '{"receiver":"telegram","status":"firing","alerts":[{"status":"firing","labels":{"alertname":"Fire","severity":"critical"},"annotations":{"message":"Something is on fire"},"startsAt":"2018-11-04T22:43:58.283995108+01:00","endsAt":"2018-11-04T22:46:58.283995108+01:00","generatorURL":"http://localhost:9090/graph?g0.expr=vector%28666%29\u0026g0.tab=1"}],"groupLabels":{"alertname":"Fire"},"commonLabels":{"alertname":"Fire","severity":"critical"},"commonAnnotations":{"message":"Something is on fire"},"externalURL":"http://localhost:9093","version":"4","groupKey":"{}:{alertname=\"Fire\"}"}' \
localhost:8080

echo Everything is done
