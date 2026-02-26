# Kubernetes ReplicaSet -- Commands Cheat Sheet

This README contains the most important **kubectl commands** you can use
to manage **ReplicaSets (RS)** in Kubernetes.

------------------------------------------------------------------------

# 📌 ReplicaSet Commands

## ✅ Create a ReplicaSet

Apply a YAML file:

``` bash
kubectl apply -f replicaset.yaml
```

------------------------------------------------------------------------

## ✅ List ReplicaSets

``` bash
kubectl get rs
```

Or:

``` bash
kubectl get replicaset
```

Show more details:

``` bash
kubectl get rs -o wide
```

------------------------------------------------------------------------

## ✅ Describe a ReplicaSet

``` bash
kubectl describe rs <replicaset-name>
```

Example:

``` bash
kubectl describe rs nginx-rs
```

------------------------------------------------------------------------

## ✅ View Pods Managed by ReplicaSet

ReplicaSets manage Pods using labels.

``` bash
kubectl get pods -l app=nginx
```

------------------------------------------------------------------------

## ✅ Scale a ReplicaSet

Increase or decrease replicas:

``` bash
kubectl scale rs <replicaset-name> --replicas=5
```

Example:

``` bash
kubectl scale rs nginx-rs --replicas=5
```

------------------------------------------------------------------------

## ✅ Edit ReplicaSet Live

``` bash
kubectl edit rs <replicaset-name>
```

Example:

``` bash
kubectl edit rs nginx-rs
```

------------------------------------------------------------------------

## ✅ Get ReplicaSet YAML Output

``` bash
kubectl get rs <replicaset-name> -o yaml
```

Example:

``` bash
kubectl get rs nginx-rs -o yaml
```

------------------------------------------------------------------------

## ✅ Delete a ReplicaSet

``` bash
kubectl delete rs <replicaset-name>
```

Example:

``` bash
kubectl delete rs nginx-rs
```

⚠️ Deleting the ReplicaSet will also delete its Pods.

------------------------------------------------------------------------

# 📌 Useful Combined Commands

## Check All Resources

``` bash
kubectl get all
```

------------------------------------------------------------------------

## Watch ReplicaSets Live

``` bash
kubectl get rs -w
```

------------------------------------------------------------------------

## Watch Pods Live

``` bash
kubectl get pods -w
```

------------------------------------------------------------------------

## ReplicaSet vs Deployment

ReplicaSets are usually managed by Deployments.

To see Deployment-created ReplicaSets:

``` bash
kubectl get rs
kubectl get deploy
```

------------------------------------------------------------------------

# ⭐ Summary Table

  Command                         Purpose
  ------------------------------- -------------------
  kubectl apply -f file.yaml      Create ReplicaSet
  kubectl get rs                  List ReplicaSets
  kubectl describe rs             Detailed info
  kubectl scale rs --replicas=N   Scale replicas
  kubectl delete rs               Remove ReplicaSet
  kubectl edit rs                 Modify live
  kubectl get rs -o yaml          Export YAML

------------------------------------------------------------------------

✅ This cheat sheet covers the essential ReplicaSet management commands.
