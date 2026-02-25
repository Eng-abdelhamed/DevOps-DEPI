# Kubernetes Deployment

##  What is a Deployment?

A **Deployment** in Kubernetes is an object used to manage applications running in Pods.

It provides:

* Pod creation
* Replica management
* Rolling updates
* Rollbacks
* Self-healing

---

## Architecture

```
Deployment
    ↓
ReplicaSet
    ↓
Pods
```

* Deployment manages ReplicaSets
* ReplicaSet maintains the desired number of Pods
* Pods run the containers

---

##  Example Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
```

---

##  What This Does

* Creates **3 replicas**
* Runs **nginx container**
* Automatically replaces failed Pods
* Supports rolling updates

---

##  Common kubectl Commands

### Create Deployment

```
kubectl apply -f deployment.yaml
```

### List Deployments

```
kubectl get deployments
```

### List Pods

```
kubectl get pods
```

### Scale Deployment

```
kubectl scale deployment nginx-deployment --replicas=5
```

### Update Image

```
kubectl set image deployment/nginx-deployment nginx=nginx:1.25
```

### Check Rollout Status

```
kubectl rollout status deployment nginx-deployment
```

### Rollback

```
kubectl rollout undo deployment nginx-deployment
```

---

## Rolling Update

Deployment updates Pods gradually without downtime.

Default strategy:

```yaml
strategy:
  type: RollingUpdate
```

It ensures:

* No downtime
* Gradual replacement of old Pods
* Easy rollback if something fails

---

##  Scaling

To increase replicas:

```
kubectl scale deployment nginx-deployment --replicas=10
```

Kubernetes automatically creates additional Pods.

---

##  Why Use Deployment?

| Feature          | Supported |
| ---------------- | --------- |
| Auto-healing     | ✅         |
| Scaling          | ✅         |
| Rolling Updates  | ✅         |
| Rollback         | ✅         |
| Production Ready | ✅         |

---

##  Deployment vs Pod

| Pod                     | Deployment            |
| ----------------------- | --------------------- |
| Single instance         | Manages multiple Pods |
| No self-healing         | Auto-healing          |
| Not production-friendly | Production ready      |
| Manual scaling          | Easy scaling          |

---

##  Best Practices

* Use **Deployment** for stateless applications
* Use **StatefulSet** for stateful applications (databases, etc.)
* Always define resource requests and limits in production
* Use labels consistently for proper selection

---

##  Summary

A Kubernetes Deployment is the standard way to run stateless applications in production. It provides scaling, self-healing, rolling updates, and rollback capabilities, making it essential for modern containerized applications.

# Kubernetes Rollout Commands

This guide covers common `kubectl rollout` commands used to manage Kubernetes Deployments.

---

## 1. Rollback a Deployment

```bash
kubectl rollout undo deployment <deploy-name> --to-revision=1
```

### Description
Rolls back a deployment to a previous revision.

- `--to-revision=1` specifies the revision number to roll back to.
- Useful when a new release causes issues and needs to be reverted.

### View Deployment History

```bash
kubectl rollout history deployment <deploy-name>
```

---

## 2. Check Rollout Status

```bash
kubectl rollout status deployment <deploy-name>
```

### Description
Displays the current status of a deployment rollout.

- Shows whether the rollout is in progress, completed, or failed.
- Commonly used in CI/CD pipelines to monitor deployment progress.

---

## 3. Pause a Rollout

```bash
kubectl rollout pause deployment <deploy-name>
```

### Description
Pauses an ongoing deployment rollout.

- Prevents new ReplicaSet updates from being applied.
- Useful when making multiple changes before resuming.

---

## 4. Resume a Rollout

```bash
kubectl rollout resume deployment <deploy-name>
```

### Description
Resumes a previously paused deployment rollout.

- Applies any pending changes.

---

## Summary

| Command | Purpose |
|----------|----------|
| `rollout undo` | Roll back to a previous revision |
| `rollout status` | Check rollout progress |
| `rollout pause` | Temporarily pause a rollout |
| `rollout resume` | Resume a paused rollout |

---

**Note:** Replace `<deploy-name>` with your actual Kubernetes Deployment name.
