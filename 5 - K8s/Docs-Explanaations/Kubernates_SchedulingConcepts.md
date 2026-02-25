# Kubernetes Scheduling Concepts: Labels, Selectors, Node Selector, Node Affinity, Pod Affinity, Taints & Tolerations

This document explains the main Kubernetes scheduling mechanisms and the difference between the operators used in Node Affinity and Pod Affinity.

---

# 1. Labels and Selectors

## Labels
Labels are key-value pairs attached to Kubernetes objects such as Nodes, Pods, Services, Deployments, etc.

Example:
```yaml
labels:
  environment: production
  app: nginx
```
Labels are used to organize, group, and select Kubernetes resources.

---

## Selectors

Selectors are used to filter Kubernetes objects based on labels.

There are two types of selectors:

### 1) Equality-based selectors
Operators:
- =
- ==
- !=

Example:
```yaml
environment = production
app != backend
```
These require an exact match comparison.

---

### 2) Set-based selectors
Operators:
- In
- NotIn
- Exists
- DoesNotExist

Example:
``` yaml
environment In (production, staging)
tier NotIn (frontend)
```
app Exists
debug DoesNotExist
Set-based selectors are more flexible and are used in affinity rules.

---

# 2. Node Selector

nodeSelector is the simplest way to constrain a Pod to run on specific Nodes.
Node Affinity is Advanced Feature , ```RequiredDuringSchedulingIgnoredDuringExecution```

It performs exact key-value matching only.

Example:
``` yaml
# In Pod Defination File
spec:
  nodeSelector:
    disktype: ssd
```
This means:
The Pod will only run on Nodes labeled with:
```disktype=ssd```

Limitations:
- Only exact matches
- No advanced operators
- Cannot express complex conditions

---

# 3. Node Affinity

Node Affinity is a more expressive and flexible version of nodeSelector.

It allows advanced matching rules using operators.

There are two main types:

## 1) RequiredDuringSchedulingIgnoredDuringExecution
- Hard requirement
- Pod will NOT be scheduled if rules are not satisfied

## 2) PreferredDuringSchedulingIgnoredDuringExecution
- Soft requirement
- Scheduler will try to place the Pod accordingly, but it is not mandatory

Example:

spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: disktype
                operator: In
                values:
                  - ssd

This means:
The Pod must run on a Node where disktype is ssd.

---

# 4. Pod Affinity and Pod Anti-Affinity

Pod Affinity controls scheduling based on other Pods' labels.

## Pod Affinity
Places a Pod close to other Pods that match certain labels.

## Pod Anti-Affinity
Prevents a Pod from being scheduled near other Pods that match certain labels.

Example:

affinity:
  podAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app
              operator: In
              values:
                - frontend
        topologyKey: "kubernetes.io/hostname"

topologyKey defines the domain:
- kubernetes.io/hostname → same node
- topology.kubernetes.io/zone → same zone

---

# 5. Taints and Tolerations

Taints are applied to Nodes.
Tolerations are applied to Pods.

They work together to repel Pods from Nodes unless explicitly allowed.

---

## Taints (Applied on Node)

Command:

kubectl taint nodes node1 key=value:NoSchedule

Taint format:
key=value:effect

Effects:
- NoSchedule → Pod will not be scheduled unless it tolerates the taint
- PreferNoSchedule → Scheduler tries to avoid placing Pods
- NoExecute → Evicts running Pods that don’t tolerate the taint

---

## Tolerations (Applied on Pod)

Example:

tolerations:
  - key: "key"
    operator: "Equal"
    value: "value"
    effect: "NoSchedule"

If the Pod has a matching toleration, it can be scheduled on that tainted Node.

Toleration Operators:
- Equal (default) → key and value must match
- Exists → key must match, value is ignored

---

# Operators in Node Affinity and Pod Affinity

The following operators are used inside matchExpressions:

## 1) In
The label's value must match one of the listed values.

Example:

operator: In
values:
  - production
  - staging

Meaning:
Label must be either production or staging.

---

## 2) NotIn
The label's value must NOT match any listed values.

Example:

operator: NotIn
values:
  - dev

Meaning:
Label must not be dev.

---

## 3) Exists
The label key must exist.
No values field is required.

Example:

operator: Exists

Meaning:
The Node/Pod must have this label key (any value is acceptable).

---

## 4) DoesNotExist
The label key must NOT exist.

Example:

operator: DoesNotExist

Meaning:
The Node/Pod must not have this label key.

---

# Difference Between Operators

In:
- Requires values
- Matches if label value is inside the provided list

NotIn:
- Requires values
- Matches if label value is NOT inside the provided list

Exists:
- Does not require values
- Matches if the label key exists

DoesNotExist:
- Does not require values
- Matches if the label key does NOT exist

---

# Final Summary

Labels → Metadata key-value pairs
Selectors → Filter resources by labels
nodeSelector → Simple exact node matching
Node Affinity → Advanced node scheduling rules
Pod Affinity → Schedule Pods relative to other Pods
Pod Anti-Affinity → Prevent Pods from running near certain Pods
Taints → Repel Pods from Nodes
Tolerations → Allow Pods to bypass taints

These tools together give full control over Kubernetes scheduling behavior.
