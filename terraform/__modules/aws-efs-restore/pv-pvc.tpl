# TODO: add variables
---

apiVersion: v1
kind: PersistentVolume
metadata:
  name: ${name}
spec:
  capacity:
    storage: 1Gi
  csi:
    driver: efs.csi.aws.com
    volumeHandle: "${fs_id}::${ap_id}"
  accessModes:
    - ReadWriteMany
  claimRef:
    kind: PersistentVolumeClaim
    namespace: default
    name: ${name}
  persistentVolumeReclaimPolicy: Delete
  storageClassName: change-me-sc
  mountOptions:
    - tls
  volumeMode: Filesystem

---

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ${name}
  namespace: default
  annotations:
    volume.beta.kubernetes.io/storage-provisioner: efs.csi.aws.com
  finalizers:
    - kubernetes.io/pvc-protection
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  volumeName: ${name}
  storageClassName: change-me-sc
  volumeMode: Filesystem
