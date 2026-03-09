# Kubernetes AWS EBS Storage Example

This project demonstrates how to use **AWS EBS volumes in Kubernetes** using:

- StorageClass
- PersistentVolumeClaim (PVC)
- Pod

The storage is dynamically provisioned using the **AWS EBS CSI Driver**.

---

# Architecture

Pod
 ↓
PersistentVolumeClaim (PVC)
 ↓
StorageClass
 ↓
AWS EBS Volume (created dynamically)

---

# Kubernetes YAML Configuration

```yaml
# Making the StorageClass
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: aws-ebs-sc
provisioner: ebs.csi.aws.com
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
---
# Making the PVC
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: aws-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: aws-ebs-sc
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
      claimName: aws-pvc
```

---

# Explanation

## 1 StorageClass

The **StorageClass** defines how Kubernetes dynamically creates storage volumes.

Key fields:

provisioner: ebs.csi.aws.com
Uses the AWS EBS CSI driver.

reclaimPolicy: Retain
The volume will NOT be deleted when the PVC is deleted.

volumeBindingMode: WaitForFirstConsumer
The volume is created only when a pod actually uses the PVC.
This ensures the volume is created in the correct **availability zone**.

---

## 2 PersistentVolumeClaim (PVC)

The **PVC requests storage** from the StorageClass.

Requested storage:

1Gi

Access mode:

ReadWriteOnce

Meaning the volume can be mounted by **one node at a time**.

The PVC references the StorageClass:

storageClassName: aws-ebs-sc

When the PVC is created, Kubernetes automatically provisions an **AWS EBS volume**.

---

## 3 Pod

The Pod runs an **NGINX container** and mounts the persistent storage.

Container image:

nginx

Volume mount location inside the container:

/data

The volume definition connects the PVC to the pod:

claimName: aws-pvc

This attaches the EBS volume to the container.

---

# Workflow

1 Create StorageClass
2 Create PVC requesting storage
3 Kubernetes provisions AWS EBS volume
4 Pod starts
5 Volume attaches to node
6 Volume mounted inside container

---

# Deploy the Configuration

Apply the YAML file:

```bash
kubectl apply -f aws-ebs.yaml
```

---

# Verify Resources

Check StorageClass:

```bash
kubectl get sc
```

Check PersistentVolumeClaim:

```bash
kubectl get pvc
```

Check PersistentVolumes:

```bash
kubectl get pv
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

Go to the mounted directory:

```bash
cd /data
```

Create a test file:

```bash
touch test.txt
ls
```

If the file appears, the EBS volume is successfully mounted.

---

# Requirements

You must have:

- Kubernetes cluster (EKS recommended)
- AWS EBS CSI Driver installed
- kubectl configured

Check if the driver is installed:

```bash
kubectl get pods -n kube-system | grep ebs
```

---

# Optional Improvements

You can specify the EBS volume type for better performance.

Example:

```yaml
parameters:
  type: gp3
  fsType: ext4
```

---

# Summary

This setup demonstrates **dynamic AWS EBS provisioning in Kubernetes**.

Components used:

StorageClass → Defines how volumes are created
PersistentVolumeClaim → Requests storage
Pod → Consumes the storage

This pattern is commonly used in **production Kubernetes environments** for persistent storage.
