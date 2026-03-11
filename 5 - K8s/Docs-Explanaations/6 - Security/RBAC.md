# Kubernetes RBAC (Role-Based Access Control)

## Overview
RBAC in Kubernetes is used to control **who can access resources** in the cluster and **what actions they can perform**.

RBAC works using four main resources:

- **Role**
- **ClusterRole**
- **RoleBinding**
- **ClusterRoleBinding**

---

## RBAC Components

### Role
A **Role** defines permissions within a **specific namespace**.

Example permissions:
- read pods
- create configmaps
- delete services

### ClusterRole
A **ClusterRole** defines permissions across the **entire cluster**.

Commonly used for:
- nodes
- persistent volumes
- cluster-wide resources

### RoleBinding
A **RoleBinding** assigns a **Role** to a subject.

Subjects can be:
- User
- Group
- ServiceAccount

RoleBinding works **inside a namespace**.

### ClusterRoleBinding
A **ClusterRoleBinding** assigns a **ClusterRole** to a subject **across the entire cluster**.

---

## Example Scenario

We want to:

- Create a namespace called **dev**
- Create a **ServiceAccount**
- Allow that ServiceAccount to **read pods only**

---

## Step 1 — Create Namespace

```bash
kubectl create namespace dev
```

---

## Step 2 — Create ServiceAccount

```bash
kubectl create serviceaccount app-user -n dev
```

---

## Step 3 — Role YAML

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: dev

rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

### Role YAML Parameters

| Field | Description |
|------|-------------|
| apiVersion | Kubernetes API version |
| kind | Type of object (Role) |
| metadata.name | Name of the role |
| metadata.namespace | Namespace where the role is applied |
| rules | List of permission rules |
| apiGroups | API group of the resource |
| resources | Target Kubernetes resources |
| verbs | Allowed actions |

Common verbs include:

- `get`
- `list`
- `watch`
- `create`
- `update`
- `patch`
- `delete`

---

## Step 4 — RoleBinding YAML

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: dev

subjects:
- kind: ServiceAccount
  name: app-user
  namespace: dev

roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

### RoleBinding Parameters

| Field | Description |
|------|-------------|
| subjects | Entity receiving permissions |
| subjects.kind | Type of subject |
| subjects.name | Name of the subject |
| subjects.namespace | Namespace of the ServiceAccount |
| roleRef | Reference to the role |
| roleRef.kind | Role or ClusterRole |
| roleRef.name | Name of the role |
| roleRef.apiGroup | RBAC API group |

---

## Apply Configuration

```bash
kubectl apply -f role.yaml
kubectl apply -f rolebinding.yaml
```

---

## Verify Resources

```bash
kubectl get roles -n dev
kubectl get rolebindings -n dev
```

---

## Test Permissions

```bash
kubectl auth can-i get pods \
--as=system:serviceaccount:dev:app-user \
-n dev
```

Expected output:

```
yes
```

---

## Summary

- **Role** defines permissions.
- **RoleBinding** assigns permissions to users, groups, or service accounts.
- RBAC ensures **secure and controlled access** inside Kubernetes clusters.
