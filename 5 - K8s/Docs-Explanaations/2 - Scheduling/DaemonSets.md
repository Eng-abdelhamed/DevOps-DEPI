# Kubernetes DaemonSet Example

This project provides a simple example of a Kubernetes **DaemonSet**.

A **DaemonSet** ensures that a copy of a Pod runs on every node (or selected nodes) in the cluster. It is commonly used for:

- Log collection (e.g., Fluent Bit, Filebeat)
- Monitoring agents (e.g., Node Exporter)
- Networking components
- Security agents

---

##  Overview

This example DaemonSet:

- Deploys one Pod per node
- Runs an `nginx` container
- Sets CPU and memory resource limits
- Tolerates control-plane node scheduling

---

##  DaemonSet Configuration

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: example-daemonset
  namespace: kube-system
  labels:
    app: example-agent
spec:
  selector:
    matchLabels:
      app: example-agent
  template:
    metadata:
      labels:
        app: example-agent
    spec:
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoSchedule"
      containers:
        - name: example-container
          image: nginx:stable
          resources:
            limits:
              memory: "200Mi"
              cpu: "200m"
            requests:
              memory: "100Mi"
              cpu: "100m"
          ports:
            - containerPort: 80
```

------------
## How to Build the Daemon Set

``` yaml
k create -f DaemonSets.yaml
# Create a Deamon Set

k describe ds <DamonSetName>
# Describe the daemon Set

k delete ds <DamonSetName>
# Delete the Damon Set , Also Delete the pods Created By The Daemon Set

```
