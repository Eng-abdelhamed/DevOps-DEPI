# Kubernetes PersistentVolume Reclaim Policies: Retain, Delete, Recycle

In Kubernetes, when a **PersistentVolumeClaim (PVC)** that is using a **PersistentVolume (PV)** is deleted, Kubernetes needs to decide what should happen to the underlying storage. This behavior is controlled by the **PersistentVolume Reclaim Policy**.

There are three possible reclaim policies:

- **Retain**
- **Delete**
- **Recycle**

These policies define what happens to the **PV and the stored data** after the PVC is removed.

---

## 1. Retain

The **Retain** policy preserves the storage and its data even after the PVC is deleted.

When the PVC is removed:
- The PV status changes to **Released**
- The data remains on the storage
- The volume cannot be reused automatically
- An administrator must manually clean the data and reconfigure the PV if it should be reused

This policy is the **safest option for important data**, such as databases or production storage.

Example PV configuration:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-retain
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/retain
```

Lifecycle example:

```
PVC deleted
   ↓
PV status becomes Released
   ↓
Data stays on disk
   ↓
Administrator decides whether to reuse or delete the data
```

Typical use cases:
- Databases
- Critical application storage
- Backup data

---

## 2. Delete

The **Delete** policy automatically removes the PersistentVolume and the underlying storage when the PVC is deleted.

When the PVC is removed:
- The PV object is deleted
- The storage backend is also deleted

This policy is commonly used with **dynamic provisioning and cloud storage** systems.

Example PV configuration:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-delete
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  hostPath:
    path: /data/delete
```

Lifecycle example:

```
PVC deleted
   ↓
PV deleted
   ↓
Underlying storage removed
```

Typical use cases:
- Temporary workloads
- Dynamically provisioned cloud volumes (AWS EBS, GCE Persistent Disk, Azure Disk)

---

## 3. Recycle

The **Recycle** policy automatically cleans the data from the volume and makes it available for reuse.

When the PVC is deleted:
- Kubernetes deletes all files inside the volume
- The PV becomes **Available** again for another claim

The recycling process typically runs a command similar to:

```
rm -rf /volume/*
```

Example PV configuration:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-recycle
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  hostPath:
    path: /data/recycle
```

Lifecycle example:

```
PVC deleted
   ↓
Data wiped from volume
   ↓
PV becomes Available again
   ↓
Another PVC can claim it
```

Important note:

The **Recycle policy is deprecated in modern Kubernetes versions**, and most clusters today use **Retain** or **Delete** instead.

---

## Comparison of Reclaim Policies

| Policy   | What happens to PV | What happens to data | Typical usage |
|----------|--------------------|----------------------|---------------|
| Retain   | PV kept            | Data preserved       | Critical storage |
| Delete   | PV removed         | Data deleted         | Dynamic cloud volumes |
| Recycle  | PV reused          | Data wiped           | Legacy clusters |

---

## Summary

PersistentVolume reclaim policies control how Kubernetes handles storage after a PVC is deleted.

- **Retain** keeps the data and requires manual cleanup.
- **Delete** removes both the PV and the underlying storage automatically.
- **Recycle** wipes the data and makes the PV available again (now deprecated).

Choosing the correct reclaim policy is important to balance **data safety, automation, and resource reuse**.
