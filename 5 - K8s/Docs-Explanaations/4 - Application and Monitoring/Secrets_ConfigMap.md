# Secrets and ConfigMaps in Kubernetes

## Overview

Kubernetes provides two important resources for managing application configuration:

- **ConfigMaps** – used to store non-sensitive configuration data.
- **Secrets** – used to store sensitive information such as passwords, tokens, and API keys.

Both resources allow you to **separate configuration from application code**, making deployments more flexible and secure.

---

# 1. ConfigMaps

A **ConfigMap** is used to store configuration data in key-value pairs.  
It allows applications to access configuration without embedding it in the container image.

## Common Use Cases

- Environment variables
- Application configuration files
- Command-line arguments
- Service configuration

---

# 2. Creating a ConfigMap

## Create from literal values

```bash
kubectl create configmap app-config \
  --from-literal=APP_ENV=production \
  --from-literal=APP_DEBUG=false
```

---

## Create from a file

```bash
kubectl create configmap app-config --from-file=config.properties
```

---

## Create using YAML

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_ENV: production
  APP_DEBUG: "false"
  APP_PORT: "8080"
```

Apply the ConfigMap:

```bash
kubectl apply -f configmap.yaml
```

---

# 3. Using ConfigMap in a Pod

## As environment variables

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-pod
spec:
  containers:
  - name: app
    image: nginx
    envFrom:
    - configMapRef:
        name: app-config
```

---

## As a volume

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-volume-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
  volumes:
  - name: config-volume
    configMap:
      name: app-config
```

---

# 4. Secrets

A **Secret** stores sensitive data such as:

- Database passwords
- API tokens
- SSH keys
- TLS certificates

Secrets are stored **base64 encoded** in Kubernetes.

---

# 5. Creating a Secret

## Create from literal values

```bash
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=supersecret
```

---

## Create using YAML

First encode the values:

```bash
echo -n "admin" | base64
echo -n "supersecret" | base64
```

Example YAML:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: YWRtaW4=
  password: c3VwZXJzZWNyZXQ=
```

Apply the secret:

```bash
kubectl apply -f secret.yaml
```

---

# 6. Using Secrets in a Pod

## As environment variables

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-pod
spec:
  containers:
  - name: app
    image: nginx
    env:
    - name: DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: username
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
```

---

## As a volume

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-volume-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secret
  volumes:
  - name: secret-volume
    secret:
      secretName: db-secret
```

---

# 7. Viewing ConfigMaps and Secrets

List ConfigMaps:

```bash
kubectl get configmaps
```

List Secrets:

```bash
kubectl get secrets
```

Describe ConfigMap:

```bash
kubectl describe configmap app-config
```

Describe Secret:

```bash
kubectl describe secret db-secret
```

---

# 8. Differences Between ConfigMaps and Secrets

| Feature | ConfigMap | Secret |
|-------|--------|--------|
| Purpose | Non-sensitive configuration | Sensitive data |
| Storage | Plain text | Base64 encoded |
| Use cases | App settings, configs | Passwords, API keys |
| Security | Less secure | More secure |

---

# 9. Best Practices

- Store **sensitive data only in Secrets**
- Avoid hardcoding credentials in images
- Use **RBAC** to restrict access to Secrets
- Rotate secrets regularly
- Use **external secret managers** when possible

Examples:

- HashiCorp Vault
- AWS Secrets Manager
- Azure Key Vault
- Google Secret Manager

---

# Summary

Kubernetes provides two mechanisms to manage configuration:

| Resource | Purpose |
|--------|---------|
| ConfigMap | Store non-sensitive configuration data |
| Secret | Store sensitive information securely |

Using these resources improves **security, portability, and maintainability** of Kubernetes applications.