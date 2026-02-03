## Ansible Variables and Playbooks

---

### Ansible Playbook Example – Installing Packages

```yaml
---
- name: Install packages
  hosts: all
  become: true
  vars:
    pkgs:
      - git
      - postgresql
      - nginx

  tasks:
    - name: Display first package
      debug:
        msg: "First package is {{ pkgs[0] }}"

    - name: Install packages
      ansible.builtin.yum:
        name: "{{ item }}"
        state: present
      loop: "{{ pkgs }}"
```

✅ Notes:

* Avoid `state: latest` unless really required
* Use FQCN (`ansible.builtin.yum`) for best practice

---

### 2️⃣ User Information Variables

```yaml
---
- name: User information
  hosts: all
  become: true
  vars:
    user:
      name: "Ahmed"
      password: "ansible"  # Not recommended (use Ansible Vault)

  tasks:
    - name: Display user info
      debug:
        msg: "User name is {{ user.name }}, password is {{ user.password }}"
```

⚠️ Never store passwords in plain text – use **Ansible Vault**.

---

### 3️⃣ Inventory File and Variables

```ini
managedhost1 ansible_host=192.168.1.1
managednode2 ansible_host=192.168.1.2

[webservers]
managedhost1
managednode2

[webservers:vars]
dns_server=10.5.5.3
```

🔹 All hosts in `webservers` share the same `dns_server` value.

#### Host Variable Overrides Group Variable

```ini
managedhost1 ansible_host=192.168.1.1 dns_server=10.5.5.4
managednode2 ansible_host=192.168.1.2

[webservers:vars]
dns_server=10.5.5.3
```

`managedhost1` will use `10.5.5.4` instead of the group value.

---

### Variable Scope (Play Level)

```yaml
---
- name: Play 1
  hosts: web2
  vars:
    ntp_server: 10.1.1.1
  tasks:
    - debug:
        var: ntp_server

- name: Play 2
  hosts: web1
  tasks:
    - debug:
        var: ntp_server
```

Error in Play 2: `ntp_server` is defined only in Play 1.

---

### 5️⃣ Inventory Variables with Lists

#### Inventory

```ini
app_list=['git','python','ansible']
```

#### Playbook

```yaml
---
- name: Install applications
  hosts: all
  become: true
  tasks:
    - name: Install packages
      ansible.builtin.yum:
        name: "{{ item }}"
        state: present
      loop: "{{ app_list }}"
```

---

### 6️⃣ Variable Precedence (Low → High)

1. Group variables
2. Host variables
3. Playbook variables
4. Extra vars (command line) ⭐

```bash
ansible-playbook playbook.yml --extra-vars "dns_server=10.5.5.5"
```
- Command-line variables have the **highest priority**.
---

### 7️⃣ Useful Magic Variables

```jinja2
{{ hostvars['web2'].ansible_host }}
{{ hostvars['web2'].ansible_facts.architecture }}
{{ hostvars['web2'].ansible_facts.devices }}
{{ hostvars['web2'].ansible_facts.mounts }}
{{ hostvars['web2'].ansible_facts.processor }}
```

Other important magic variables:

* `inventory_hostname` → current host name
* `group_names` → list of groups the host belongs to

---

### 8️⃣ Verifying Playbooks in Ansible

* **Check Mode (Dry Run)**

  ```bash
  ansible-playbook playbook.yml --check
  ```

* **Diff Mode**

  ```bash
  ansible-playbook playbook.yml --diff
  ```

* **Syntax Check**

  ```bash
  ansible-playbook playbook.yml --syntax-check
  ```

* **Verbose Output**

  ```bash
  -v  -vv  -vvv
  ```

* **Ansible Lint**

  ```bash
  ansible-lint playbook.yml
  ```

Checks best practices, bugs, and style issues.

---

## Conditions and Loops

### Example: Run Task Only on a Specific Host

```yaml
---
- name: Conditional execution example
  hosts: all
  tasks:
    - name: Run service task only on node02
      ansible.builtin.service:
        name: nginx
        state: started
      when: inventory_hostname == "node02"
```

Best practice:

* Use `inventory_hostname` instead of comparing IPs
* Conditions should be simple and readable

---

### Example: make users on a Specific Host using loop

``` yaml
---
---
- name: Create users
  hosts: all
  become: true
  vars:
    users:
      - name: ahmed
        uid: 1050
      - name: ahmed1
        uid: 1060
      - name: ahmed2
        uid: 1070
      - name: ahmed3
        uid: 1080
      - name: ahmed4
        uid: 1090
      - name: ahmed5
        uid: 1200
      - name: ahmed6
        uid: 1210
      - name: ahmed7
        uid: 1220
  tasks:
    - name: Create users
      ansible.builtin.user:
        name: "{{ item.name }}"
        uid: "{{ item.uid }}"
        state: present  # absent to delete the username
      loop: "{{ users }}"

```
### Example: make users on a Specific Host using with_
``` yaml
---
---
- name: Create users
  hosts: all
  become: true
  vars:
    users:
      - name: ahmed
        uid: 1050
      - name: ahmed1
        uid: 1060
      - name: ahmed2
        uid: 1070
      - name: ahmed3
        uid: 1080
      - name: ahmed4
        uid: 1090
      - name: ahmed5
        uid: 1200
      - name: ahmed6
        uid: 1210
      - name: ahmed7
        uid: 1220
  tasks:
    - name: Create users
      ansible.builtin.user:
        name: "{{ item.name }}"
        uid: "{{ item.uid }}"
        state: present  # absent to delete the username
      with_items : "{{ users }}"


```



**This README follows Ansible best practices and ansible-lint rules.**


