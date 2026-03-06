
# Understanding Init Containers and Sidecar Containers in Kubernetes

## 1. Multi-Container Pods in Kubernetes

A **Pod** can contain multiple containers that share:

- Network namespace (same IP/port space)
- Storage volumes
- Lifecycle

Typically, containers inside a Pod cooperate to deliver a service.

Example:
- **Main container:** Web application
- **Sidecar container:** Logging agent

Both containers usually run **for the entire Pod lifecycle**.

If a container exits and the Pod’s **restartPolicy** allows it (`Always` or `OnFailure`), Kubernetes restarts it.

---

# 2. Restart Behavior in Multi-Container Pods

Important rule:

 Kubernetes treats the **Pod as a single scheduling unit**, but **containers are restarted individually by the kubelet**.

Meaning:

- If **one container crashes**, Kubernetes **restarts only that container**, not the entire Pod.
- Other containers **keep running**.

Example Pod:

```

containers:

* web-app
* logging-agent

```

If `web-app` crashes:

```

web-app -> restarted
logging-agent -> continues running

```

Pod restart behavior depends on:

```

restartPolicy:
Always
OnFailure
Never

```

Default:

```

restartPolicy: Always

```

---

# 3. What Are Init Containers?

An **Init Container** runs **before the main containers start**.

Characteristics:

- Run **sequentially**
- Must **finish successfully**
- Each must **exit with code 0**
- Main containers **do not start until all init containers complete**

Execution order:

```

Init Container 1 -> completes
Init Container 2 -> completes
↓
Main Containers start

````

---

## Why Use Init Containers?

They are useful for **preparing the environment**.

Common tasks:

- Waiting for services
- Downloading configuration
- Running database migrations
- Setting up files or permissions

Examples:

- Wait for database
- Fetch secrets
- Clone repository

---

# Example Init Container

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
spec:
  initContainers:
  - name: init-myservice
    image: busybox:1.31
    command:
      - sh
      - -c
      - until nslookup myservice; do echo waiting; sleep 2; done

  containers:
  - name: myapp
    image: busybox
    command:
      - sh
      - -c
      - echo "App started"; sleep 3600
````

Flow:

```
1️⃣ init-myservice runs
2️⃣ waits until service resolves
3️⃣ exits successfully
4️⃣ main container starts
```

---

# 4. Init Container Failure Behavior

If an init container fails:

```
Pod restart
↓
Init containers start again
↓
Main containers wait
```

So the sequence restarts from the **first init container**.

---

# 5. Sidecar Containers

A **Sidecar container** runs **alongside the main container** and supports it.

Typical uses:

* Logging
* Metrics collection
* Proxy
* Configuration reload
* Data synchronization

Example:

```
Main App
+
Log Collector
```

Both run together until the Pod stops.

---

# 6. Native Sidecar Containers (Kubernetes 1.33+)

Starting **Kubernetes v1.33**, Kubernetes introduced **Native Sidecar Containers**.

Before this feature, sidecars were just **normal containers**, and developers had to implement hacks to control startup/shutdown ordering.

Now Kubernetes provides **lifecycle management for sidecars**.

---

## How Native Sidecars Work

Native sidecars are declared under:

```
initContainers
```

but with:

```
restartPolicy: Always
```

This tells Kubernetes:

> Treat this init container as a **sidecar**.

Behavior:

1️⃣ Sidecar starts **before main containers**
2️⃣ Kubernetes waits for it to become **ready**
3️⃣ Main containers start
4️⃣ Sidecar runs **for the entire Pod lifecycle**
5️⃣ Sidecar stops **after main containers exit**

---

# Example Native Sidecar

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-example
spec:
  initContainers:
  - name: sidecar-logger
    image: busybox:1.31
    restartPolicy: Always
    command:
      - sh
      - -c
      - while true; do echo "Sidecar running"; sleep 10; done

  containers:
  - name: main-app
    image: busybox:1.31
    command:
      - sh
      - -c
      - echo "Main app starting"; sleep 60
```

Execution order:

```
1️⃣ sidecar-logger starts
2️⃣ Kubernetes confirms it is running
3️⃣ main-app starts
4️⃣ both run together
5️⃣ main-app exits
6️⃣ sidecar stops
```

---

# 7. Init Containers vs Sidecar Containers

| Feature            | Init Container | Sidecar Container  |
| ------------------ | -------------- | ------------------ |
| Runs before app    | ✅              | ✅ (native sidecar) |
| Runs with app      | ❌              | ✅                  |
| Must complete      | ✅              | ❌                  |
| Runs sequentially  | ✅              | ❌                  |
| Restarted if fails | Pod restarts   | Container restarts |
| Common usage       | setup tasks    | logging, proxies   |

---

# 8. Typical Real-World Architecture

Example:

```
Pod
│
├── Init Container
│      Download config
│
├── Main Container
│      Web application
│
└── Sidecar Container
       Log collector
```

Execution flow:

```
Init container
      ↓
Main + Sidecar running together
      ↓
Pod termination
```

---

# Key Takeaways

✔ **Init containers prepare the environment before the application starts.**
✔ **Sidecar containers support the main application during runtime.**
✔ **Native sidecars (K8s 1.33+) provide lifecycle control.**
✔ **Containers restart individually based on restartPolicy.**

```

