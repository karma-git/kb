# Overview
Примеры.
<details>
  <summary>Просмотр подов на определенной ноде кластера</summary>

  **Список подов во всех нейспейсах на определенной ноде.**
  ```bash
$ kubectl get pods -A --field-selector spec.nodeName=<NodeName>
  ```
  **Список подов в определенных неймспейсах.**
  ```bash
kubectl get pods --namespace={dev,test} --field-selector spec.nodeName=<NodeName>
  ```
  **Список подов во всех неймспейсах исключая определенные.**
  ```bash
$ kubectl get pods -A --field-selector spec.nodeName=<NodeName>,metadata.namespace!=kube-system
  ```
</details>
