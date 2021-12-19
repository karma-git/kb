{
  "apiVersion": "v1",
  "items": [
    // ConfigMap
    {
      "apiVersion": "v1",
      "kind": "ConfigMap",
      "metadata": {
        "name": "configmap-" + std.extVar('color'),
        "labels": {
          "app": "myapp",
          "deploy": std.extVar('color')
        }
      },
      "data": {
        "default.conf": std.format("server {\n    listen       80 default_server;\n    server_name  _;\n\n    default_type text/plain;\n\n    location / {\n        return 200 'I am %s!\\n';\n    }\n}\n", std.extVar('color'))
      }
    },
    // Deployment
    {
      "apiVersion": "apps/v1",
      "kind": "Deployment",
      "metadata": {
        "name": "myapp-" + std.extVar('color'),
        "labels": {
          "app": "myapp",
          "deploy": std.extVar('color')
        }
      },
      "spec": {
        "replicas": 2,
        "selector": {
          "matchLabels": {
            "app": "myapp",
            "deploy": std.extVar('color')
          }
        },
        "strategy": {
          "type": "Recreate"
        },
        "template": {
          "metadata": {
            "labels": {
              "app": "myapp",
              "deploy": std.extVar('color')
            }
          },
          "spec": {
            "containers": [
              {
                "image": "nginx:1.13",
                "name": "myapp",
                "ports": [
                  {
                    "containerPort": 80
                  }
                ],
                "readinessProbe": {
                  "failureThreshold": 3,
                  "httpGet": {
                    "path": "/",
                    "port": 80
                  },
                  "periodSeconds": 10,
                  "successThreshold": 1,
                  "timeoutSeconds": 1
                },
                "livenessProbe": {
                  "failureThreshold": 3,
                  "httpGet": {
                    "path": "/",
                    "port": 80
                  },
                  "periodSeconds": 10,
                  "successThreshold": 1,
                  "timeoutSeconds": 1,
                  "initialDelaySeconds": 10
                },
                "resources": {
                  "requests": {
                    "cpu": "50m",
                    "memory": "100Mi"
                  },
                  "limits": {
                    "cpu": "100m",
                    "memory": "100Mi"
                  }
                },
                "volumeMounts": [
                  {
                    "name": "config",
                    "mountPath": "/etc/nginx/conf.d/"
                  }
                ]
              }
            ],
            "volumes": [
              {
                "name": "config",
                "configMap": {
                  "name": "configmap-" + std.extVar('color')
                }
              }
            ]
          }
        }
      }
    }
  ],
  "kind": "List",
  "metadata": {
    "resourceVersion": "",
    "selfLink": ""
  }
}
