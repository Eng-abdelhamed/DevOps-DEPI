## Task
---
Develop a playbook named welcomemessgae.yml on the production group to show a welcome messga  after ssh authentication that contain the current system_owner , abd to reach out to user support@xyz.com in case of any issues , hint use **/etc/motd** file

`` templates/welcome.j2``
```yaml
Hello To The Server Name {{inventory_hostname}} 
with the user {{username}}
if there is any error contact {{email}}
```
in the yaml playbook``welcomemessgae.yml``
```yaml
---
- name: Showing the system user rn
  hosts: all
  become: false
  tasks:
   - name: SysUser
     command: " whoami "
     register: sys_user

- name: Editing the Message Of The Day 
  hosts: all
  vars:
   username: "{{sys_user.stdout}}"
   email: "support@xyz.com"
  tasks:
   - name: Editing the file
     template:
      src: "templates/welcome.j2"
      dest: "/etc/motd"

```

