# Kubernetes EFS Storage Example

This project demonstrates how to use **AWS EFS (Elastic File System)** with **Kubernetes using the EFS CSI driver**. The setup provisions shared persistent storage that can be mounted by multiple pods simultaneously.

---

## Architecture Overview

The configuration includes three Kubernetes resources:

1. **StorageClass** – Defines how EFS storage is dynamically provisioned.
2. **PersistentVolumeClaim (PVC)** – Requests storage from the StorageClass.
3. **Deployment** – Creates pods that mount and use the shared EFS volume.

```
Pods (3 replicas)
        │
        ▼
PersistentVolumeClaim
        │
        ▼
StorageClass (EFS CSI Driver)
        │
        ▼
AWS EFS File System
```

---

## 1. StorageClass

The **StorageClass** defines how Kubernetes dynamically provisions storage using the AWS EFS CSI driver.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: efs-sc
provisioner: efs.csi.aws.com
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
parameters:
  provisioningMode: efs-ap
  fileSystemId: fs-xxxxxxx
  directoryPerms: "700"
```

### Explanation

**provisioner**

```
efs.csi.aws.com
```

This tells Kubernetes to use the **AWS EFS CSI Driver** to provision storage.

**reclaimPolicy**

```
Delete
```

When the PVC is deleted, the associated storage resource will also be deleted.
Another option is:

```
Retain
```

which keeps the data even after the PVC is deleted.

**volumeBindingMode**

```
WaitForFirstConsumer
```

This delays volume binding until a pod actually uses the claim, allowing Kubernetes to schedule resources more efficiently.

**parameters**

These parameters configure how the EFS storage is created.

**provisioningMode**

```
efs-ap
```

This mode uses **EFS Access Points**, which provide isolated directories for Kubernetes workloads.

**fileSystemId**

```
fs-xxxxxxx
```

This is the **EFS filesystem ID** from AWS.

You can find it in:

```
AWS Console → EFS → File Systems
```

**directoryPerms**

```
"700"
```

Sets the directory permissions for the created EFS access point.

---

## 2. PersistentVolumeClaim (PVC)

The **PVC** requests storage from the StorageClass.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: efs-pvc
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: efs-sc
```

### Explanation

**accessModes**

```
ReadWriteMany
```

This allows **multiple pods to read and write at the same time**, which is a key feature of **EFS**.

Other storage types often use:

```
ReadWriteOnce
```

which only allows a single node to mount the volume.

**storage request**

```
1Gi
```

This value is required by Kubernetes but **EFS automatically scales**, so the actual storage size is not limited.

**storageClassName**

```
efs-sc
```

This connects the PVC to the **StorageClass** defined earlier.

---

## 3. Deployment

The **Deployment** creates three pods that mount the shared EFS storage.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: efs-deployment
  labels:
    app: efs-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: efs-app
  template:
    metadata:
      labels:
        app: efs-app
    spec:
      containers:
      - name: efs-container
        image: centos
        command: ["/bin/sh"]
        args: ["-c", "while true; do echo hello world >> /data/file.txt ; sleep 10; done"]
        volumeMounts:
        - name: efs-volume
          mountPath: /data
      volumes:
      - name: efs-volume
        persistentVolumeClaim:
          claimName: efs-pvc
```

### Explanation

**replicas**

```
3
```

The deployment runs **three pods simultaneously**.

**container image**

```
centos
```

A simple Linux container used to run a shell command.

**command**

```
while true; do echo hello world >> /data/file.txt ; sleep 10; done
```

This continuously writes the text:

```
hello world
```

to a file inside the mounted EFS volume every **10 seconds**.

**volumeMounts**

```
mountPath: /data
```

Mounts the persistent storage inside the container at `/data`.

**volumes**

```
persistentVolumeClaim:
  claimName: efs-pvc
```

This attaches the container to the previously created **PVC**, which is backed by EFS.

---

## Result

All **three pods share the same filesystem**.

Each pod writes to the same file:

```
/data/file.txt
```

Example content:

```
hello world
hello world
hello world
hello world
...
```

Multiple pods are writing to the **same shared storage simultaneously**.

---

## Requirements

Before deploying this configuration, make sure you have:

* A running **EKS cluster**
* An **AWS EFS filesystem**
* The **EFS CSI driver installed**

Example installation:

```
eksctl create addon \
--name aws-efs-csi-driver \
--cluster <cluster-name> \
--region <region>
```

---

## Deploy the Resources

Apply the configuration:

```
kubectl apply -f efs.yaml
```

Check the resources:

```
kubectl get pods
kubectl get pvc
kubectl get storageclass
```

---

## Summary

This setup demonstrates how to:

* Use **AWS EFS with Kubernetes**
* Dynamically provision persistent storage
* Share storage across multiple pods
* Mount EFS volumes using the **EFS CSI driver**

Common use cases include:

* shared uploads
* application logs
* machine learning datasets
* web application file storage
