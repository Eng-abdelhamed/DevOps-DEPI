# Kubernetes Resource Requests and Limits

This document explains **Resource Requests and Limits** in Kubernetes, how they work, and how to configure them properly.

---

##  What Are Resource Requests and Limits?

Kubernetes allows you to specify how much **CPU** and **Memory** a container:

- **Requests** → Minimum resources guaranteed for the container.
- **Limits** → Maximum resources the container is allowed to use.

These settings help Kubernetes schedule Pods efficiently and prevent resource starvation.

---

##  Resource Requests

A **request** defines the minimum amount of CPU or memory required.

- Used by the scheduler to decide which node can run the Pod.
- Guarantees the container at least this amount (if available).

Example:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu : "250m"
    memory: "1024Mi"
```


------
## Full Yaml Code Pod Defination With Request and Limits
``` yaml

apiVersion: v1
kind: Pod
metadata:
  name: testing-pod
spec:
  containers:
    - name: test-container
      image: nginx
      resources:
        requests:
          cpu: "250m"
          memory: "1024Mi"
        limits:
          cpu : "500m"
          memory: "2084Mi"

```
