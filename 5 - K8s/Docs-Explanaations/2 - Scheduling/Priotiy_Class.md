# Kubernetes PriorityClass (README)

This README explains what **PriorityClass** is in Kubernetes, why you’d use it, and how to configure it safely.

---

## What is PriorityClass?

A **PriorityClass** is a cluster-wide Kubernetes resource that assigns a **priority value** to Pods.  
Kubernetes uses this priority to decide:

- Scheduling order: higher-priority Pods get scheduled before lower-priority Pods when resources are limited.
- Preemption: if the cluster is full, Kubernetes may evict (preempt) lower-priority Pods to make room for a higher-priority Pod.

In short: PriorityClass ensures critical workloads run before less important ones.

---

## Key Concepts

### 1) value
- A higher numeric value means higher priority.
- Define a clear internal range (example: 0–100000).

### 2) globalDefault
- If set to true, Pods without priorityClassName use this class.
- Only one PriorityClass should be global default.

### 3) preemptionPolicy
Controls whether a Pod can evict lower-priority Pods.

- PreemptLowerPriority (default): may evict lower-priority Pods.
- Never: will not preempt other Pods.

### 4) description
A human-readable explanation of the purpose of the class.

---

## When to Use PriorityClass

Use PriorityClass when:

- Running critical platform services (ingress, DNS, monitoring)
- Running business-critical APIs
- Managing multi-tenant clusters
- Running batch workloads that can be deprioritized

---

## Example: Create a High PriorityClass

```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 1000
globalDefault: false
preemptionPolicy: PreemptLowerPriority
description: "For critical services that must schedule before normal workloads."
```

Apply it:

```bash
kubectl apply -f priorityclass-high.yaml
```

---

## Example: Use PriorityClass in a Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-critical-api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-critical-api
  template:
    metadata:
      labels:
        app: my-critical-api
    spec:
      priorityClassName: high-priority
      containers:
        - name: api
          image: nginx:stable
          ports:
            - containerPort: 80
```

---

## Example: Important Without Preemption

```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: important-no-preempt
value: 900
globalDefault: false
preemptionPolicy: Never
description: "Important workloads that should not evict other pods."
```

---

## How Preemption Works

1. A high-priority Pod cannot be scheduled.
2. Scheduler identifies lower-priority Pods that can be removed.
3. Those Pods are evicted.
4. The high-priority Pod is scheduled.

Note:
- Preemption is not guaranteed.
- PodDisruptionBudgets can affect eviction behavior.

---

## Best Practices

- Keep PriorityClasses limited and well documented.
- Use clear naming (platform-critical, business-critical, default, batch-low).
- Prefer preemptionPolicy: Never unless eviction is truly required.
- Avoid using system critical classes for application workloads.
- Combine with:
  - Resource requests/limits
  - PodDisruptionBudgets
  - Cluster Autoscaler

---

## Useful Commands

List PriorityClasses:

```bash
kubectl get priorityclass
```

Describe one:

```bash
kubectl describe priorityclass high-priority
```

Check Pod priority:

```bash
kubectl get pod <pod-name> -o jsonpath='{.spec.priorityClassName}{"\n"}'
kubectl get pod <pod-name> -o jsonpath='{.spec.priority}{"\n"}'
```

---

## Example Priority Tier Model

- 1000  = Critical services
- 500   = Important services
- 0     = Normal workloads
- -100  = Batch / Best effort workloads

Adjust based on your SLAs and cluster design.