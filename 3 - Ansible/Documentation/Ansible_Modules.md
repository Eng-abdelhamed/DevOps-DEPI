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

- **fetch** : Copy remote file to my control node and store them in file tree oraganized by host name
  
   ```bash
        fetch:
          src: "/home/remotefile"
          dest: "/tmp/localfile"

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
