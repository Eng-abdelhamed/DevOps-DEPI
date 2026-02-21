# Kubernetes Pods -- Explanation

## What is a Pod?

A **Pod** is the smallest and most basic deployable unit in Kubernetes.

It represents a single instance of an application running in the
cluster.

A Pod can contain:

-   One container (most common)
-   Multiple containers working together (sidecar pattern)

------------------------------------------------------------------------

## Key Characteristics of Pods

-   Pods run containers
-   Pods share the same network namespace
-   Pods share storage volumes
-   Pods are ephemeral (temporary)

------------------------------------------------------------------------

## Basic Pod YAML Example

``` yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
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

### 1. metadata

Contains identifying information:

-   name
-   labels
-   annotations

### 2. spec

Defines the Pod configuration, including:

-   containers
-   volumes
-   restart policy

### 3. containers

List of containers running inside the Pod.

Each container includes:

-   image
-   ports
-   environment variables
-   resource limits

------------------------------------------------------------------------

## How Pods Work

1.  You create a Pod definition in YAML.
2.  Kubernetes schedules the Pod on a Node.
3.  The container runtime pulls the image.
4.  Containers start running inside the Pod.

------------------------------------------------------------------------

## Pod Lifecycle

Pods go through phases:

-   Pending → Pod is being scheduled
-   Running → Containers are running
-   Succeeded → Completed successfully
-   Failed → Pod terminated with errors
-   Unknown → Node communication issue

------------------------------------------------------------------------

## Limitations of Pods

Pods are not self-healing by themselves.

If a Pod dies, Kubernetes does NOT automatically recreate it unless
managed by a controller like:

-   Deployment
-   ReplicaSet
-   ReplicationController
-   StatefulSet

------------------------------------------------------------------------

## When to Use Pods?

Direct Pod creation is mainly for:

-   Testing
-   Learning
-   Debugging

In production, Pods are usually created and managed by controllers.

------------------------------------------------------------------------

## Summary

A Pod is the fundamental execution unit in Kubernetes that runs
containers. It provides shared networking and storage, but it is usually
managed by higher-level controllers for scalability and reliability.
