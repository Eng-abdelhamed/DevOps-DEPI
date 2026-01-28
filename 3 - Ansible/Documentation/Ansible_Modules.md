# Ansible Modules 
--------------------------------
 - System admin task is all about managing files : writing configuration , Moving them , organizing 
 - Ansible have some file modules , that ease the way to react with files 
- ----------------------------------------------
 - **file** : Create and modify file 
   ``` bash
        file:
            path:  /home/admin/filebyplay
            state: file / directory / absent
            owner: root
            group: root
            mode:  664
            setype: httpd_sys_content_t
   ```

- **Copy** : Copy content of the file to new file
   ``` bash
        copy:
           src: "/home/admin/myfile"
           dest: "/tmp/remote/file"
   ```

- **fetch** : Copy remote file to my control node and store them in file tree oraganized by host name # hint: Destination must be Directory
  
   ```bash
        fetch:
          src: "/home/remotefile"
          dest: "/tmp/localDirectory" 
          # hint: Destination must be Directory

   ```

- **name** : Sync local file to remote file as rsync command (transfer the difference)
  ```bash
    name:
      src:
      dest:
  ```

- **lineinfile**: Adding / removing single line to a file in remote host
  ```bash
    lineinfile:
        path: /tmp/remotefile
        line: 'first update'
        state: present # add ,  
        # apsent : delete
  ```
- **blockinfile** : Adding / removing block  to a file in remote host
    ``` bash
        blockinfile:
          path: /tmp/remotefile
          block: | # Completing in another line 

            removing last line and added an entire block
            remotly
          state: present
    ```

------------------------------------------------------
## Extra hand on Labs:
### jinja2 Templates

- **Jinja2** : tmeplate file is very powerful tool to autmoatic make host-specific configuration by the help  of ansible variables Facts , loops , Condition

```bash
{{ansible_managed}}
This is my first jinja2 Template
```
```bash
The linux Distro for this host {{inventory_hostname}} is {{ansible_facts['distribution]}}
```
``` bash
playbook_variable= {{playbook_variable}}
```
--- 
**If Statement in Jinja 2 Templates**

- Using Condition and Loops: 

  ```bash
  {% if ansible_facts['memfree_mb'] > 1490 %}
  System is IDLE and has enought memory
  {% else %}
  System is Busy
  {% endif %}

  ```

  - loops:

   ```bash
  # IP HOSTNAME
  {% for host in group['all'] %}
  {{hostvars[host]['ansible_facts']['enp0s8']['ipv4']['address']}} {{hostvars[host]['ansible_facts']['hostname']}}
  {% endfor %}
   ```