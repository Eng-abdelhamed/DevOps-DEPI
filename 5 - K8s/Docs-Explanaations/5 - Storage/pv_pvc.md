# Kubernetes Storage (Volumes, hostPath, PersistentVolume, PersistentVolumeClaim)

Kubernetes containers are **ephemeral**, meaning their filesystem is temporary. When a container stops or restarts, its data may be lost. To solve this, Kubernetes provides **Volumes and Persistent Storage**.

---

# 1. Basic Volume

A **Volume** is storage attached to a Pod and mounted inside a container.

Characteristics:
- Exists as long as the Pod exists
- Can be shared between containers in the same Pod
- Data usually deleted when Pod is removed (depends on volume type)

Example using `emptyDir`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-example
spec:
  containers:
  - name: app
    image: busybox
    command: ["sleep","3600"]
    volumeMounts:
    - name: myvolume
      mountPath: /data
  volumes:
  - name: myvolume
    emptyDir: {}
```

Explanation:

```
Pod
 ├── Container
 │     └── /data
 └── Volume (emptyDir)
```

- `emptyDir` is created when the Pod starts
- Deleted when the Pod is removed

---

# 2. hostPath Volume

A **hostPath volume** mounts a directory from the **node filesystem** into a Pod.

Used mainly for:
- Development
- Testing
- Single node clusters

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-example
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: host-storage
      mountPath: /data
  volumes:
  - name: host-storage
    hostPath:
      path: /data
```

Architecture:

```
Node filesystem
      │
      ▼
/data (node directory)
      │
      ▼
Pod container
      │
      ▼
/data (inside container)
```

Important:
- Pod must run on the same node
- Not recommended for production clusters

---

# 3. PersistentVolume (PV)

A **PersistentVolume** is a piece of storage in the cluster that exists independently of Pods.

It is usually created by the **cluster administrator**.

Example:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-dolfined
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data
```

Explanation:

```
Cluster Storage
     │
     ▼
PersistentVolume (pv-dolfined)
     │
     ▼
Node path /data
```

Key fields:

| Field | Description |
|-----|-----|
| capacity | total storage |
| accessModes | how it can be mounted |
| hostPath | actual storage location |

Access Modes:

| Mode | Meaning |
|-----|-----|
| ReadWriteOnce (RWO) | one node can read/write |
| ReadOnlyMany (ROX) | many nodes read only |
| ReadWriteMany (RWX) | many nodes read/write |

---

# 4. PersistentVolumeClaim (PVC)

A **PersistentVolumeClaim** is a request for storage by a user or Pod.

It automatically binds to a suitable **PersistentVolume**.

Example:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
  volumeName: pv-dolfined
```

Explanation:

```
User requests storage
        │
        ▼
PersistentVolumeClaim
        │
        ▼
Matches PersistentVolume
```

PVC requirements must match PV:

- Access mode
- Storage size
- StorageClass (if used)

---

# 5. Pod Using PVC

Once PVC is bound, a Pod can use it.

Example:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dolfined
spec:
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: dolfinvolume
      mountPath: /data
  volumes:
  - name: dolfinvolume
    persistentVolumeClaim:
      claimName: myclaim
```

Storage flow:

```
Pod
 │
 ▼
PVC (myclaim)
 │
 ▼
PV (pv-dolfined)
 │
 ▼
Node directory (/data)
```

Anything written to `/data` inside the container will be stored persistently.

Example:

```
kubectl exec -it dolfined -- sh
cd /data
echo hello > file.txt
```

This file is saved on the node path `/data`.

---

# 6. Full Storage Workflow

```
Administrator creates PV
        │
        ▼
User creates PVC
        │
        ▼
Kubernetes binds PVC → PV
        │
        ▼
Pod mounts PVC
        │
        ▼
Container writes data to storage
```

---

# 7. Quick Comparison

| Feature | Volume | hostPath | PV/PVC |
|------|------|------|------|
| Scope | Pod | Node | Cluster |
| Persistence | Temporary | Persistent | Persistent |
| Production use | Sometimes | Rarely | Yes |
| Managed by | Pod | Pod | Cluster |

---

# 8. Summary

- **Volumes** provide storage for Pods.
- **emptyDir** is temporary storage.
- **hostPath** mounts a directory from the node.
- **PersistentVolume (PV)** represents cluster storage.
- **PersistentVolumeClaim (PVC)** requests storage.
- Pods mount storage using PVC.

This model separates:
- **Storage provider (PV)**
- **Storage consumer (PVC)**
