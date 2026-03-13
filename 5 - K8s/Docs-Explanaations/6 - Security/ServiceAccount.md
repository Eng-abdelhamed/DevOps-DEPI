# Kubernetes ServiceAccount

## Overview

A **ServiceAccount** in Kubernetes provides an **identity for applications (Pods)** running inside the cluster.
It allows Pods to **authenticate with the Kubernetes API Server** and interact with cluster resources according to the **permissions granted via RBAC**.

ServiceAccounts are commonly used when:

- Applications need to interact with the Kubernetes API
- Controllers or operators manage cluster resources
- CI/CD jobs run inside Kubernetes
- Workloads require secure API authentication

---

# Key Concepts

## What is a ServiceAccount?

A **ServiceAccount (SA)** is a Kubernetes object that:

- Represents an identity for Pods
- Uses authentication tokens to communicate with the API server
- Works with **RBAC (Role and RoleBinding)** to define permissions

Each namespace automatically has a **default ServiceAccount**, but it is best practice to create a **dedicated ServiceAccount per application**.

---

# Architecture Flow

1. Pod uses a **ServiceAccount**
2. Kubernetes mounts a **token** inside the Pod
3. Pod uses the token to authenticate with the **API Server**
4. API Server checks **RBAC permissions**
5. Access is **granted or denied**

---

# Step 1 — Create a Namespace

```bash
kubectl create namespace dev
```

---

# Step 2 — Create a ServiceAccount

You can create a ServiceAccount using the CLI.

```bash
kubectl create serviceaccount app-serviceaccount -n dev
```

Verify it:

```bash
kubectl get serviceaccounts -n dev
```

---

# Step 3 — ServiceAccount YAML

Example manifest file `serviceaccount.yaml`.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-serviceaccount
  namespace: dev
```

Apply the configuration:

```bash
kubectl apply -f serviceaccount.yaml
```

---

# ServiceAccount YAML Parameters

| Field | Description |
|------|-------------|
| apiVersion | Defines the Kubernetes API version used |
| kind | Specifies the resource type (ServiceAccount) |
| metadata | Object metadata |
| metadata.name | Name of the ServiceAccount |
| metadata.namespace | Namespace where the ServiceAccount exists |

---

# Step 4 — Use ServiceAccount in a Pod

A Pod can specify which ServiceAccount it should use.

Example `pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: demo-pod
  namespace: dev

spec:
  serviceAccountName: app-serviceaccount

  containers:
  - name: nginx
    image: nginx
```

Apply the Pod:

```bash
kubectl apply -f pod.yaml
```

---

# Pod Configuration Parameters

| Field | Description |
|------|-------------|
| serviceAccountName | Specifies the ServiceAccount used by the Pod |
| containers | List of containers running in the Pod |
| name | Container name |
| image | Container image |

---

# Verify Pod ServiceAccount

Check the Pod configuration.

```bash
kubectl get pod demo-pod -n dev -o yaml
```

Look for the following field:

```
serviceAccountName: app-serviceaccount
```

---

# Retrieve ServiceAccount Token (Kubernetes 1.24+)

To generate a token for the ServiceAccount:

```bash
kubectl create token app-serviceaccount -n dev
```

---

# Default ServiceAccount

Every namespace contains a **default ServiceAccount**.

Check it:

```bash
kubectl get serviceaccounts -n dev
```

Example output:

```
NAME                   SECRETS   AGE
default                1         10d
app-serviceaccount     1         2m
```

If a Pod does not specify a ServiceAccount, it will automatically use the **default ServiceAccount**.

---

# Security Best Practices

- Do **not rely on the default ServiceAccount** for applications.
- Create a **separate ServiceAccount per workload**.
- Always configure **RBAC permissions**.
- Follow the **Principle of Least Privilege**.
- Rotate tokens when necessary.

---

# Common Commands

Create ServiceAccount

```bash
kubectl create serviceaccount app-serviceaccount -n dev
```

List ServiceAccounts

```bash
kubectl get serviceaccounts -n dev
```

Describe ServiceAccount

```bash
kubectl describe serviceaccount app-serviceaccount -n dev
```

Generate token

```bash
kubectl create token app-serviceaccount -n dev
```

---

# Summary

- **ServiceAccount** provides identity for workloads inside Kubernetes.
- Used for **authentication with the API Server**.
- Works with **RBAC Roles and RoleBindings** to control permissions.
- Best practice is to create **dedicated ServiceAccounts per application** rather than using the default one.
