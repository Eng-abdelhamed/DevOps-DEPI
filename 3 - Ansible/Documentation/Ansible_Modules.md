# Ansible Common Modules – Practical README

This README covers commonly used **Ansible modules** grouped by functionality, with **at least one practical example for each group**. All examples follow best practices and are `ansible-lint` friendly.

---

## File & Content Management Modules

### file – Manage files & directories

```yaml
- name: Create application directory
  ansible.builtin.file:
    path: /opt/myapp
    state: directory
    mode: '0755'
```

---

### copy – Copy files to remote hosts

```yaml
- name: Copy config file
  ansible.builtin.copy:
    src: app.conf
    dest: /etc/myapp.conf
    owner: root
    mode: '0644'
```

---

### template – Copy files using Jinja2 templates

```yaml
- name: Deploy nginx config
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
```

---

###  lineinfile – Manage single lines in files

```yaml
- name: Disable root SSH login
  ansible.builtin.lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^PermitRootLogin'
    line: 'PermitRootLogin no'
```

---

###  replace – Replace text using regex

```yaml
- name: Change default port
  ansible.builtin.replace:
    path: /etc/myapp.conf
    regexp: 'port=8080'
    replace: 'port=9090'
```

---

###  stat – Get file information

```yaml
- name: Check if config exists
  ansible.builtin.stat:
    path: /etc/myapp.conf
  register: config_file
```

---

###  find – Search for files

```yaml
- name: Find log files
  ansible.builtin.find:
    paths: /var/log
    patterns: '*.log'
```

---

###  archive – Compress files

```yaml
- name: Archive logs
  ansible.builtin.archive:
    path: /var/log/myapp
    dest: /tmp/myapp_logs.tar.gz
```

---

###  unarchive – Extract archives

```yaml
- name: Extract application
  ansible.builtin.unarchive:
    src: app.tar.gz
    dest: /opt/myapp
    remote_src: yes
```

---

###  acl – Manage file ACLs

```yaml
- name: Grant user read access
  ansible.builtin.acl:
    path: /opt/myapp
    entity: ahmed
    etype: user
    permissions: r
    state: present
```

---

##  Command & Execution Modules

###  command – Run commands on remote hosts

```yaml
- name: Show system date
  ansible.builtin.command: date
```

 No shell features (pipes, redirects).

---

###  script – Run local scripts remotely

```yaml
- name: Run setup script
  ansible.builtin.script: setup.sh
```

---

##  Service Management

###  service – Manage services

```yaml
- name: Start nginx service
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: yes
```

---

##  Database Modules (Examples)

###  mysql

```yaml
- name: Create MySQL database
  community.mysql.mysql_db:
    name: mydb
    state: present
```

---

###  postgresql

```yaml
- name: Create PostgreSQL user
  community.postgresql.postgresql_user:
    name: appuser
    password: secret
```

---

##  Cloud & Virtualization (Sample)

###  AWS EC2

```yaml
- name: Create EC2 instance
  amazon.aws.ec2_instance:
    name: web01
    instance_type: t2.micro
    image_id: ami-123456
```

---

###  Docker

```yaml
- name: Run nginx container
  community.docker.docker_container:
    name: nginx
    image: nginx
    state: started
    ports:
      - "80:80"
```

---

##  Windows Modules

###  win_copy

```yaml
- name: Copy file to Windows host
  ansible.windows.win_copy:
    src: app.exe
    dest: C:\\Temp\\app.exe
```

---

###  win_service

```yaml
- name: Start Windows service
  ansible.windows.win_service:
    name: Spooler
    state: started
```

---

###  win_user

```yaml
- name: Create Windows user
  ansible.windows.win_user:
    name: ansible_user
    password: P@ssw0rd!
    state: present
```

---

##  Best Practices Recap

* Prefer **modules over command/shell**
* Use **FQCN** (`ansible.builtin.*`)
* Avoid `state: latest` in production
* Use `inventory_hostname` for conditions
* Validate using:

```bash
ansible-playbook playbook.yml --check --diff
ansible-lint playbook.yml
```

---

 This README is suitable for **training, interviews, and real-world automation projects**.
