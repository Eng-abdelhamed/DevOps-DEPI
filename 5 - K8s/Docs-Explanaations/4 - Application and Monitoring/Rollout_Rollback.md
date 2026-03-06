# Rollout and Rollback in Kubernetes

## Overview

Kubernetes provides built-in mechanisms to safely update applications and recover from failed deployments.  
Two key concepts used in deployment management are:

- **Rollout** – Gradually updating an application to a new version.
- **Rollback** – Reverting an application to a previous stable version.

These mechanisms help maintain **application availability, stability, and reliability** during updates.

---

# 1. What is a Rollout?

A **rollout** is the process of deploying a new version of an application.  
Kubernetes performs rollouts gradually to avoid downtime.

Rollouts typically occur when:

- A container image is updated
- Environment variables change
- Resource limits are modified
- Deployment configuration changes

Kubernetes uses **rolling updates by default**, meaning old pods are replaced gradually with new ones.

---

# 2. Example Deployment

Below is a simple deployment example.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  strategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: nginx:1.19
        ports:
        - containerPort: 80
```

Create the deployment:

```bash
kubectl apply -f deployment.yaml
```

---

# 3. Rolling Update Strategy

Kubernetes updates pods gradually using the **RollingUpdate** strategy.

Key advantages:

- No downtime
- Gradual replacement of pods
- Automatic health checks

Example configuration:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 1
    maxSurge: 1
```

Explanation:

| Parameter | Description |
|----------|-------------|
| maxUnavailable | Maximum pods unavailable during update |
| maxSurge | Maximum extra pods created during update |

---

# 4. Updating an Application (Rollout)

Update the container image to trigger a rollout.

```bash
kubectl set image deployment/my-app my-app=nginx:1.21
```

This command updates the image and Kubernetes starts the rollout automatically.

---

# 5. Check Rollout Status

Monitor rollout progress using:

```bash
kubectl rollout status deployment/my-app
```

Example output:

```
deployment "my-app" successfully rolled out
```

---

# 6. View Rollout History

Kubernetes stores the history of deployment revisions.

```bash
kubectl rollout history deployment/my-app
```

Example output:

```
REVISION  CHANGE-CAUSE
1         Initial deployment
2         Updated nginx image
```

View details of a specific revision:

```bash
kubectl rollout history deployment/my-app --revision=2
```

---

# 7. Pause and Resume Rollout

Sometimes you may want to pause a rollout to investigate issues.

Pause rollout:

```bash
kubectl rollout pause deployment/my-app
```

Resume rollout:

```bash
kubectl rollout resume deployment/my-app
```

---

# 8. What is a Rollback?

A **rollback** restores a deployment to a previous stable version if a rollout fails or causes issues.

This allows quick recovery without redeploying the entire application.

---

# 9. Perform a Rollback

Rollback to the previous revision:

```bash
kubectl rollout undo deployment/my-app
```

Rollback to a specific revision:

```bash
kubectl rollout undo deployment/my-app --to-revision=1
```

---

# 10. Verify Rollback

Check rollout status after rollback:

```bash
kubectl rollout status deployment/my-app
```

Verify running pods:

```bash
kubectl get pods
```

---

# 11. Useful Commands

Check deployments:

```bash
kubectl get deployments
```

Describe deployment:

```bash
kubectl describe deployment my-app
```

Check rollout history:

```bash
kubectl rollout history deployment/my-app
```

Check rollout status:

```bash
kubectl rollout status deployment/my-app
```

Rollback deployment:

```bash
kubectl rollout undo deployment/my-app
```

---

# Best Practices

- Always use **RollingUpdate strategy**
- Monitor rollout status before proceeding
- Keep deployment history for safe rollbacks
- Use **health probes (readiness/liveness)** for safe updates
- Test new versions in staging before production

---

# Summary

Kubernetes rollout and rollback mechanisms help manage application updates safely.

| Feature | Description |
|--------|-------------|
| Rollout | Deploy a new version of an application |
| Rolling Update | Gradual replacement of pods |
| Rollout History | Track deployment revisions |
| Rollback | Revert to a previous stable version |

These features ensure **zero downtime deployments and quick recovery from failures**.