# Kubernetes ReplicaSet -- Explanation

## What is a ReplicaSet?

A **ReplicaSet (RS)** is a Kubernetes controller that ensures a
specified number of identical Pod replicas are running at all times.

ReplicaSet is the modern replacement for **ReplicationController**.

------------------------------------------------------------------------

## Key Responsibilities

-   Maintains the desired number of Pod replicas
-   Automatically creates new Pods if they fail
-   Removes extra Pods if too many are running
-   Works mainly as part of Deployments

------------------------------------------------------------------------

## Basic ReplicaSet YAML Example

``` yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3
  selector:
    matchLabels:
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

Defines how many Pod replicas should run.

### 2. selector.matchLabels

Defines how ReplicaSet identifies the Pods it manages.

⚠️ Must match the labels inside the template.

### 3. template

Defines the Pod specification that will be replicated.

------------------------------------------------------------------------

## How ReplicaSet Works

1.  You define replicas (e.g., 3).
2.  Kubernetes creates 3 Pods.
3.  If a Pod is deleted or crashes → ReplicaSet creates a new one.
4.  If more Pods exist → ReplicaSet deletes extra Pods.

------------------------------------------------------------------------

## ReplicaSet vs ReplicationController

  -----------------------------------------------------------------------
  Feature        ReplicationController                 ReplicaSet
  -------------- ------------------------------------- ------------------
  Selector       Equality-based only                   Supports set-based
  Support                                              selectors

  API Version    v1                                    apps/v1

  Modern Use     Legacy                                Current standard

  Used by        No                                    Yes
  Deployment                                           
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## ReplicaSet and Deployment

ReplicaSets are usually not created directly.

Instead, Kubernetes Deployments manage ReplicaSets automatically,
providing:

-   Rolling updates
-   Rollbacks
-   Version control

------------------------------------------------------------------------

## When to Use ReplicaSet?

Direct use is rare, but useful for:

-   Learning Kubernetes controllers
-   Understanding Deployment internals
-   Simple replica management

For production, use **Deployment**.

------------------------------------------------------------------------

## Summary

A ReplicaSet ensures high availability by maintaining a stable number of
Pod replicas. It is the modern successor of ReplicationController and is
usually managed through Deployments.
