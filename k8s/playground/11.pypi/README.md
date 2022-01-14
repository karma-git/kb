# Overview

Need to store and share python packages privatly.

## Install

```shell
$ minikube start
$ kubectl create namespace pypiserver
$ helm repo add owkin https://owkin.github.io/charts
# helm show values owkin/pypiserver > pypiserver-values.yaml
$ helm -n pypiserver upgrade --install pypiserver owkin/pypiserver
#  watch kubectl -n pypiserver get po
$ kubectl -n pypiserver port-forward svc/pypiserver-pypiserver 8080:8080
```

Now pypi server should be available at http://127.0.0.1:8080

## Publish python package

Move to directory with `heads-tails` project.

Add our local pypi repo:
```shell
poetry config repositories.minikube http://127.0.0.1:8080
```

Build and publish package:
```shell
poetry publish --repository minikube --build
```
> !NOTE: you should press enter on username

## [Install](./heads-tails/README.md#Install)
---
## Links

### pypi, pypi server
- [pypiserver](https://github.com/pypiserver/pypiserver)
- [Private PyPI server](https://medium.com/zaitra/private-pypi-server-on-kubernetes-locally-using-minikube-72c262e2b629)
- [owkkin/pypiserver chart](https://github.com/owkin/charts/tree/master/pypiserver)
- [Private PyPI server](https://medium.com/zaitra/private-pypi-server-on-kubernetes-locally-using-minikube-72c262e2b629)
- [owkkin/pypiserver chart](https://github.com/owkin/charts/tree/master/pypiserver)
### poetry
- [poetry](https://python-poetry.org/docs/)
- [Poetry with a Private Repository](https://m0rk.space/posts/2018/Sep/24/using-poetry-with-a-private-repository/)

## Ideas

- [HA setup - pypicloud ](https://pypicloud.readthedocs.io/en/latest/index.html)
- Nexus/Artifactory
- CI/CD pipeline
- publish traditionally
