local app = import 'utils.libsonnet';
local objName() = std.format('%s-%s', [app.name, std.extVar('color')],);
function(canary=false) {
  apiVersion: 'v1',
  items: [
    // Service
    {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: {
        labels: {
          app: app.name,
        },
        name: objName(),
        namespace: app.namespace,
      },
      spec: {
        ports: [
          {
            name: 'http',
            port: app.port,
            protocol: 'TCP',
            targetPort: app.port,
          },
        ],
        selector: {
          app: app.name,
          deploy: std.extVar('color'),
        },
        type: 'ClusterIP',
      },
    },
    // Service External
    {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: {
        name: objName(),
        namespace: 'kube-system',
        labels: {
          app: app.name,
        },
      },
      spec: {
        type: 'ExternalName',
        externalName: std.format('%s.%s.svc.cluster.local', [objName(), app.namespace],),
      },
    },
    // Ingress release / stable
    (
      if canary then {
        apiVersion: 'networking.k8s.io/v1',
        kind: 'Ingress',
        metadata: {
          name: objName(),
          namespace: 'kube-system',
          labels: {
            app: app.name,
          },
          annotations: {
            'nginx.ingress.kubernetes.io/canary': 'true',
            'nginx.ingress.kubernetes.io/canary-by-cookie': 'tester',
          },
        },
        spec: {
          ingressClassName: 'nginx',
          rules: [
            {
              host: std.format('%s.%s', [app.name, app.LocalDNS]),
              http: {
                paths: [
                  {
                    pathType: 'Prefix',
                    path: '/',
                    backend: {
                      service: {
                        name: objName(),
                        port: {
                          number: app.port,
                        },
                      },
                    },
                  },
                ],
              },
            },
          ],
        },
      } else {
        apiVersion: 'networking.k8s.io/v1',
        kind: 'Ingress',
        metadata: {
          name: objName(),
          namespace: 'kube-system',
          labels: {
            app: app.name,
          },
        },
        spec: {
          ingressClassName: 'nginx',
          rules: [
            {
              host: std.format('%s.%s', [app.name, app.LocalDNS]),
              http: {
                paths: [
                  {
                    pathType: 'Prefix',
                    path: '/',
                    backend: {
                      service: {
                        name: objName(),
                        port: {
                          number: app.port,
                        },
                      },
                    },
                  },
                ],
              },
            },
          ],
        },
      }
    ),
  ],
  kind: 'List',
  metadata: {
    resourceVersion: '',
    selfLink: '',
  },
}
