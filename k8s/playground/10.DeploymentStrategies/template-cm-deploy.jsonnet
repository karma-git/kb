local app = import 'utils.libsonnet';
{
  apiVersion: 'v1',
  items: [
    // ConfigMap
    {
      apiVersion: 'v1',
      kind: 'ConfigMap',
      metadata: {
        name: 'configmap-' + std.extVar('color'),
        namespace: app.namespace,
        labels: {
          app: app.name,
          deploy: std.extVar('color'),
        },
      },
      data: {
        'default.conf': std.format("server {\n    listen       %d default_server;\n    server_name  _;\n\n    default_type text/plain;\n\n    location / {\n        return 200 'I am %s!\\n';\n    }\n}\n", [app.port, std.extVar('color')]),
      },
    },
    // Deployment
    {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: {
        name: app.name + '-' + std.extVar('color'),
        namespace: app.namespace,
        labels: {
          app: app.name,
          deploy: std.extVar('color'),
        },
      },
      spec: {
        replicas: app.replicaCount,
        selector: {
          matchLabels: {
            app: app.name,
            deploy: std.extVar('color'),
          },
        },
        strategy: {
          type: 'Recreate',
        },
        template: {
          metadata: {
            labels: {
              app: app.name,
              deploy: std.extVar('color'),
            },
          },
          spec: {
            containers: [
              {
                image: app.imageName,
                name: app.name,
                ports: [
                  {
                    containerPort: app.port,
                  },
                ],
                readinessProbe: {
                  failureThreshold: 3,
                  httpGet: {
                    path: '/',
                    port: app.port,
                  },
                  periodSeconds: 10,
                  successThreshold: 1,
                  timeoutSeconds: 1,
                },
                livenessProbe: {
                  failureThreshold: 3,
                  httpGet: {
                    path: '/',
                    port: app.port,
                  },
                  periodSeconds: 10,
                  successThreshold: 1,
                  timeoutSeconds: 1,
                  initialDelaySeconds: 10,
                },
                resources: {
                  requests: {
                    cpu: app.resources.requests.cpu,
                    memory: app.resources.requests.memory,
                  },
                  limits: {
                    cpu: app.resources.limits.cpu,
                    memory: app.resources.limits.memory,
                  },
                },
                volumeMounts: [
                  {
                    name: 'config',
                    mountPath: '/etc/nginx/conf.d/',
                  },
                ],
              },
            ],
            volumes: [
              {
                name: 'config',
                configMap: {
                  name: 'configmap-' + std.extVar('color'),
                },
              },
            ],
          },
        },
      },
    },
  ],
  kind: 'List',
  metadata: {
    resourceVersion: '',
    selfLink: '',
  },
}
