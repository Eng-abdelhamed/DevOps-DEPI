# Kubernetes ReplicationController (RC) -- Explanation

## What is a ReplicationController?

A **ReplicationController (RC)** is a Kubernetes resource that ensures a
specified number of Pod replicas are running at all times.

If a Pod crashes or is deleted, the ReplicationController automatically
creates a new one to maintain the desired state.

------------------------------------------------------------------------

## Key Responsibilities

-   Maintains a fixed number of Pod replicas
-   Recreates Pods if they fail
-   Replaces terminated Pods
-   Ensures high availability of applications

------------------------------------------------------------------------

## Basic Structure

``` yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

------------------------------------------------------------------------

## Important Fields

### 1. replicas

Defines how many Pod copies should run.

### 2. selector

Specifies how the ReplicationController finds and manages Pods. It must
match the labels defined in the Pod template.

### 3. template

Defines the Pod configuration that will be replicated.

------------------------------------------------------------------------

## How It Works

1.  You define the desired number of replicas (e.g., 3).
2.  Kubernetes creates 3 Pods based on the template.
3.  If one Pod crashes, RC automatically creates a new one.
4.  If extra Pods exist, RC removes them.

This is called **Desired State Management**.

------------------------------------------------------------------------

## Limitations

ReplicationController is considered **legacy** and has been replaced by:

-   ReplicaSet
-   Deployment (recommended for production use)

RC does NOT support: - Rolling updates - Rollbacks - Advanced update
strategies

------------------------------------------------------------------------

## When to Use It?

ReplicationController is mainly used for: - Learning Kubernetes basics -
Understanding how controllers work internally

In real-world production systems, **Deployment** is preferred.

------------------------------------------------------------------------

## Summary

ReplicationController ensures application availability by maintaining a
stable number of running Pods. However, it is now mostly replaced by
ReplicaSet and Deployment in modern Kubernetes environments.
