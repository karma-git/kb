{
  name: 'myapp',
  namespace: 'default',
  LocalDNS: 'dev',
  replicaCount: 2,
  image: {
    repository: 'nginx',
    tag: '1.13',
  },
  port: 80,
  resources: {
    limits: {
      cpu: '100m',
      memory: '100Mi',
    },
    requests: {
      cpu: '50m',
      memory: '100Mi',
    },
  },
  // concatenate repo + imageTag
  imageName: self.image.repository + ':' + self.image.tag,
}
