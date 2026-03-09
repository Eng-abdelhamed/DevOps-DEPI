# Kubernetes AWS EBS Static Persistent Volume Example

This example demonstrates **static provisioning of an AWS EBS volume in Kubernetes** using:

- PersistentVolume (PV)
- PersistentVolumeClaim (PVC)
- Pod

Unlike dynamic provisioning, the **PersistentVolume is created manually first**, and then the PVC binds to it.

---

# Architecture

Pod
↓
PersistentVolumeClaim (PVC)
↓
PersistentVolume (PV)
↓
AWS EBS Volume

---

# Kubernetes YAML Configuration

```yaml
# Making a Static PV
apiVersion: v1
kind: PersistentVolume
metadata:
  name: aws-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  csi:
    driver: ebs.csi.aws.com
    volumeHandle: aws-pv
    fsType: ext4
---
# Making the PVC
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: aws-vpc
spec:
  volumeName: aws-pv
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
# Making the Pod
apiVersion: v1
kind: Pod
metadata:
  name: aws-pod
spec:
  containers:
  - name: aws-container
    image: nginx
    volumeMounts:
    - name: aws-volume
      mountPath: /data
  volumes:
  - name: aws-volume
    persistentVolumeClaim:
      claimName: aws-vpc
```

---

# Explanation

## 1 PersistentVolume (PV)

The **PersistentVolume** represents an existing storage resource in the cluster.

In this example it represents an **AWS EBS volume**.

Key configuration:

storage: 1Gi
Defines the storage capacity.

accessModes: ReadWriteOnce
The volume can be mounted by **one node at a time**.

persistentVolumeReclaimPolicy: Retain
The volume will **not be deleted when the PVC is deleted**.

CSI configuration:

driver: ebs.csi.aws.com
Uses the AWS EBS CSI driver.

volumeHandle: aws-pv
Represents the **actual AWS EBS volume ID** (in real scenarios this should be the real EBS volume ID).

fsType: ext4
Defines the filesystem used by the volume.

---

## 2 PersistentVolumeClaim (PVC)

The **PVC requests storage from the existing PV**.

Key configuration:

volumeName: aws-pv
This forces the PVC to bind to the specific PV named **aws-pv**.

storage request:

1Gi

access mode:

ReadWriteOnce

Once the PVC is created, Kubernetes binds it to the **PersistentVolume**.

---

## 3 Pod

The Pod runs an **NGINX container** and mounts the persistent storage.

Container image:

nginx

Volume mount path inside container:

/data

The volume definition connects the Pod to the PVC:

claimName: aws-vpc

This allows the container to access the **AWS EBS volume**.

---

# Workflow

1 Create PersistentVolume
2 Create PersistentVolumeClaim
3 PVC binds to the PV
4 Create Pod
5 Pod mounts the volume
6 Container accesses storage at /data

---

# Deploy the Configuration

Apply the YAML file:

```bash
kubectl apply -f aws-static-pv.yaml
```

---

# Verify Resources

Check PersistentVolumes:

```bash
kubectl get pv
```

Check PersistentVolumeClaims:

```bash
kubectl get pvc
```

Check Pod:

```bash
kubectl get pods
```

---

# Test the Volume

Enter the pod:

```bash
kubectl exec -it aws-pod -- bash
```

Navigate to mounted storage:

```bash
cd /data
```

Create a test file:

```bash
touch test.txt
ls
```

If the file appears, the **EBS volume is successfully mounted**.

---

# Important Note

In a real AWS environment, the **volumeHandle** must be the actual EBS volume ID.

Example:

```
volumeHandle: vol-0abc123456789xyz
```

You can find the volume ID in the **AWS EC2 → Volumes section**.

---

# Summary

This example demonstrates **static provisioning in Kubernetes**.

Components used:

PersistentVolume → Manually defined storage
PersistentVolumeClaim → Requests that storage
Pod → Consumes the storage

Static provisioning is useful when you want **full control over the underlying storage resource**.
