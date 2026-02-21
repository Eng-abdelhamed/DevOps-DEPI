# Kubernetes Pods & ReplicationControllers -- Commands Cheat Sheet

This README collects the most useful commands you can run for both
**Pods** and **ReplicationControllers (RC)**.

------------------------------------------------------------------------

# 📌 POD Commands

## ✅ Create a Pod

### Apply YAML file

``` bash
kubectl apply -f pod.yaml
```

### Run Pod directly (imperative)

``` bash
kubectl run nginx-pod --image=nginx --port=80
```

------------------------------------------------------------------------

## ✅ List Pods

``` bash
kubectl get pods
```

With more details:

``` bash
kubectl get pods -o wide
```

------------------------------------------------------------------------

## ✅ Describe a Pod

``` bash
kubectl describe pod <pod-name>
```

Example:

``` bash
kubectl describe pod nginx-pod
```

------------------------------------------------------------------------

## ✅ View Pod Logs

``` bash
kubectl logs <pod-name>
```

Follow logs continuously:

``` bash
kubectl logs -f <pod-name>
```

If multiple containers:

``` bash
kubectl logs <pod-name> -c <container-name>
```

------------------------------------------------------------------------

## ✅ Execute Commands Inside a Pod

``` bash
kubectl exec -it <pod-name> -- /bin/bash
```

Example:

``` bash
kubectl exec -it nginx-pod -- sh
```

------------------------------------------------------------------------

## ✅ Delete a Pod

``` bash
kubectl delete pod <pod-name>
```

Example:

``` bash
kubectl delete pod nginx-pod
```

------------------------------------------------------------------------

# 📌 REPLICATIONCONTROLLER (RC) Commands

## ✅ Create a ReplicationController

``` bash
kubectl apply -f rc.yaml
```

------------------------------------------------------------------------

## ✅ List ReplicationControllers

``` bash
kubectl get rc
```

Or full name:

``` bash
kubectl get replicationcontroller
```

------------------------------------------------------------------------

## ✅ Describe a ReplicationController

``` bash
kubectl describe rc <rc-name>
```

Example:

``` bash
kubectl describe rc nginx
```

------------------------------------------------------------------------

## ✅ View Pods Managed by RC

``` bash
kubectl get pods -l app=nginx
```

------------------------------------------------------------------------

## ✅ Scale ReplicationController

``` bash
kubectl scale rc <rc-name> --replicas=5
```

Example:

``` bash
kubectl scale rc nginx --replicas=5
```

------------------------------------------------------------------------

## ✅ Delete a ReplicationController

``` bash
kubectl delete rc <rc-name>
```

⚠️ This will also delete all Pods created by it.

------------------------------------------------------------------------

# 📌 Combined Useful Commands

## Check Everything Running

``` bash
kubectl get all
```

------------------------------------------------------------------------

## Watch Resources Live

``` bash
kubectl get pods -w
```

------------------------------------------------------------------------

## Get YAML Output of Running Object

``` bash
kubectl get pod <pod-name> -o yaml
```

``` bash
kubectl get rc <rc-name> -o yaml
```

------------------------------------------------------------------------

# ⭐ Quick Summary

  Resource     Purpose
  ------------ ----------------------------------------
  Pod          Runs containers (smallest unit)
  RC           Ensures a fixed number of Pod replicas
  Deployment   Modern replacement for RC

------------------------------------------------------------------------

✅ This README gives you the essential kubectl commands for working with
Pods and ReplicationControllers.
