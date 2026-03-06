# Scaling and Auto Scaling in Kubernetes

## Overview
Kubernetes provides powerful mechanisms to automatically scale applications based on workload demand. Scaling ensures applications remain available, responsive, and cost-efficient by dynamically adjusting the number of running instances.

Kubernetes supports two primary scaling methods:

- Manual Scaling
- Automatic Scaling

This document explains the different scaling approaches and how to configure them.

---

# 1. Manual Scaling

Manual scaling allows you to increase or decrease the number of pod replicas manually.

## Example

```bash
kubectl scale deployment my-app --replicas=5
```

This command updates the Deployment to run 5 pod replicas.

### Verify scaling

```bash
kubectl get pods
kubectl get deployment my-app
```

### When to use manual scaling

- Testing environments
- Predictable workloads
- Emergency scaling

---

# 2. Horizontal Pod Autoscaler (HPA)

The Horizontal Pod Autoscaler automatically adjusts the number of pod replicas based on CPU, memory, or custom metrics.

## Architecture

Metrics Server → HPA Controller → Deployment/ReplicaSet → Pods

## Requirements

- Metrics Server installed in the cluster
- Resource requests defined in the deployment

Example deployment snippet:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

---

## Create an HPA

```bash
kubectl autoscale deployment my-app \
  --cpu-percent=50 \
  --min=2 \
  --max=10
```

Explanation:

| Parameter | Description |
|---|---|
| --cpu-percent | Target CPU utilization |
| --min | Minimum number of pods |
| --max | Maximum number of pods |

---

## Check HPA status

```bash
kubectl get hpa
```

Example output:

```
NAME     REFERENCE           TARGETS   MINPODS   MAXPODS   REPLICAS
my-app   Deployment/my-app   40%/50%   2         10        3
```

---

# 3. Vertical Pod Autoscaler (VPA)

The Vertical Pod Autoscaler automatically adjusts CPU and memory requests/limits for containers.

Instead of changing the number of pods, it changes the resources assigned to each pod.

## Use Cases

- Resource optimization
- Memory-intensive workloads
- Long-running applications

Example VPA configuration:

```yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: my-app-vpa
spec:
  targetRef:
    apiVersion: "apps/v1"
    kind: Deployment
    name: my-app
  updatePolicy:
    updateMode: "Auto"
```

---

# 4. Cluster Autoscaler

The Cluster Autoscaler automatically adjusts the number of nodes in a cluster.

It adds nodes when:

- Pods cannot be scheduled due to lack of resources.

It removes nodes when:

- Nodes are underutilized.

Supported on:

- AWS (EKS)
- GCP (GKE)
- Azure (AKS)

---

# Scaling Levels in Kubernetes

| Scaling Type | What it Scales |
|---|---|
| Horizontal Pod Autoscaler | Number of Pods |
| Vertical Pod Autoscaler | Pod Resources |
| Cluster Autoscaler | Number of Nodes |

---

# Best Practices

- Always define resource requests and limits
- Use HPA for stateless applications
- Monitor scaling with Prometheus + Grafana
- Set reasonable min and max replica values

---

# Useful Commands

Check pods:

```bash
kubectl get pods
```

Check HPA:

```bash
kubectl get hpa
```

Describe HPA:

```bash
kubectl describe hpa my-app
```

---

# Monitoring Autoscaling

Common tools used:

- Prometheus
- Grafana
- Kubernetes Metrics Server
- KEDA (event-driven autoscaling)

---

# Summary

Kubernetes offers multiple scaling strategies to maintain application performance:

- Manual Scaling – direct control
- HPA – scales pods based on metrics
- VPA – adjusts container resources
- Cluster Autoscaler – scales nodes

Using these mechanisms together ensures high availability, efficiency, and optimal resource utilization.