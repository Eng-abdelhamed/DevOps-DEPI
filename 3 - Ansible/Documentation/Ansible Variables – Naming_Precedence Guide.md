# Ansible Variables – Naming & Precedence Guide

This README explains **how Ansible finds variables**, **how to name variable files**, and **the order of precedence** Ansible uses when the same variable is defined in multiple places.

---

## 1. Variable File Naming Rules

### Group Variables

If your inventory contains a group named `cairo`:

```ini
[cairo]
managednode1
managednode2
```

Ansible will automatically load variables from:

```text
group_vars/cairo.yml
```

or:

```text
group_vars/cairo/main.yml
```

✅ **The filename or directory name MUST match the group name exactly**.

---

### Host Variables

If your inventory contains a host named `managednode1`:

```ini
[cairo]
managednode1
```

Ansible will load variables from:

```text
host_vars/managednode1.yml
```

or:

```text
host_vars/managednode1/main.yml
```

✅ **The filename or directory name MUST match the host name exactly**.

---

## 2. Variable Names Inside Files

The variable names inside `group_vars` or `host_vars` files **do NOT need to match** the group or host name.

Example:

```yaml
users:
  - name: ahmed
    groups: wheel
```

Naming variables like `cairo_users` is optional and a style choice, not a requirement.

---

## 3. Correct Way to Create Variable Files

❌ Avoid creating files without YAML extensions:

```bash
echo "user: ahmed" >> group_vars/cairo
```

✅ Correct example:

```bash
echo "users:" >> group_vars/cairo.yml
echo "  - name: ahmed" >> group_vars/cairo.yml
```

Recommended (edit with an editor):

```yaml
users:
  - name: ahmed
    groups: wheel
```

---

## 4. Variable Precedence (Mental Model)

### The "Voice in the Room" Model

**The loudest voice wins.**

From highest priority to lowest priority:

```
CLI (extra vars)
 ↓
Play vars
 ↓
Task vars / set_fact
 ↓
Host vars
 ↓
Group vars
 ↓
Role defaults
```

---

### One-Line Memory Hook

> **"Closer to the host wins — unless I yell from the CLI."**

---

## 5. Practical Example

### group_vars/cairo.yml

```yaml
timezone: Africa/Cairo
```

### host_vars/managednode1.yml

```yaml
timezone: UTC
```

### CLI override

```bash
ansible-playbook site.yml -e "timezone=Europe/Berlin"
```

### Final value used by Ansible:

```text
Europe/Berlin
```

Because:

```
CLI > host_vars > group_vars
```

---

## 6. Best Practices

* Use `group_vars` for **common configuration**
* Use `host_vars` only for **exceptions**
* Use CLI variables (`-e`) for **temporary overrides or testing only**
* Keep role defaults as **safe fallback values**

---

## 7. Common Mistake

❌ Thinking group vars override host vars

✅ Reality:

```
host_vars override group_vars
```

---

## 8. Using Variables in a Playbook

```yaml
- name: Create users
  user:
    name: "{{ item.name }}"
    groups: "{{ item.groups | default(omit) }}"
  loop: "{{ users }}"
```

---

This README is intended as a **quick reference** for daily Ansible work and interviews.
