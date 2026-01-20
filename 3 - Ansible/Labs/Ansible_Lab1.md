# Ansible Lab Project - Training Exercise

## Project Setup

### Create mylabproject Ansible directory:
```bash
mkdir -p /home/admin/mylabproject
cd /home/admin/mylabproject
```

---

## Inventory Configuration

### Create a custom static inventory file named `inventory` in `/home/admin/mylabproject`

**Inventory Structure:**

| Hostname/IP | Environment | Purpose | Location |
|------------|-------------|---------|----------|
| Managednode1 | production | Web Server | Cairo |
| Managednode2 | production | Database Server | Cairo |
| Managednode3 | DR | Web Server | Alexandria |
| Managednode4 | DR | Database Server | Alexandria |
| 5.89.1.1.20 | Development | | Cairo |
| Servera.dolfin.com | Testing | | Riyadh |
| Serverb.dolfin.com | Testing | | Riyadh |
| Serverc.dolfin.com | Testing | | Riyadh |
| 50.6.51.123 | | | |

**Sample Inventory File Structure:**
```ini
50.6.51.123

[production]
managednode1 ansible_host=<IP_ADDRESS>
managednode2 ansible_host=<IP_ADDRESS>

[DR]
managednode3 ansible_host=<IP_ADDRESS>
managednode4 ansible_host=<IP_ADDRESS>

[Development]
5.89.1.1.20

[testing]
servera.dolfin.com
serverb.dolfin.com
serverc.dolfin.com

[webserver]
managednode1
managednode3

[database]
managednode2
managednode4

[cairo:children]
production
Development

[alexandria:children]
DR

[riyadh:children]
testing
```

---

## Lab Exercises

### **Exercise 1: List Ansible Inventory Nodes**

**Question:** Use Ansible to list all managed nodes, ungrouped nodes, and Cairo Nodes.

**Answer:**
```bash
# List all managed nodes
ansible all --list-hosts -i inventory

# List ungrouped nodes
ansible ungrouped --list-hosts -i inventory

# List Cairo nodes
ansible cairo --list-hosts -i inventory
```

**Tips & Hints:**
- `--list-hosts` shows all hosts that match the pattern without executing any tasks
- `all` is a special keyword that matches all hosts in inventory
- `ungrouped` is a special group containing hosts not in any group
- Use `-i inventory` to specify your inventory file

**Expected Output Example:**
```
hosts (3):
  managednode1
  managednode2
  5.89.1.1.20
```

---

### **Exercise 2: Create User with Hashed Password**

**Question:** Create a user named 'devops' on production hosts using Ansible Ad-hoc commands with password 'dolfined'. (Hint: Password to be hashed using sha512 and mysecret key)

**Step 1: Generate SHA512 Hash with Custom Salt**
```bash
ansible localhost -m debug -a "msg={{ 'dolfined' | password_hash('sha512', 'mysecretkey') }}"
```

**Step 2: Create User with Generated Hash**
```bash
ansible production -m ansible.builtin.user -a "name=devops password='$6$mysecretkey$<GENERATED_HASH>' state=present shell=/bin/bash createhome=yes" -b
```

**Complete Command Example:**
```bash
ansible production -m ansible.builtin.user -a "name=devops password='$6$mysecretkey$pHTQDvWXpAfvfDU7P8hlwIwIInEqguDc/KL5DTEGrymn9XCCVMuxAgxXWEaBDAVNSPibLbjh/eQ9lWuELJ2cn0' state=present" -b
```

**Tips & Hints:**
- Use single quotes around the entire password hash to prevent shell interpretation
- The `-b` flag is required for privilege escalation (sudo)
- Ad-hoc commands use `key=value` format, NOT `key: value`
- The hash starts with `$6$` which indicates SHA512
- Using the same salt will produce the same hash (useful for consistency)
- Password hash syntax: `{{ 'password' | password_hash('sha512', 'salt') }}`

**Alternative Methods:**
```bash
# Using mkpasswd
mkpasswd --method=sha-512 --salt=mysecretkey

# Using Python
python3 -c "import crypt; print(crypt.crypt('dolfined', '\$6\$mysecretkey\$'))"
```

**Verify User Creation:**
```bash
ansible production -m command -a "id devops" -b
```

---

### **Exercise 3: Create Ansible Configuration File**

**Question:** Create an ansible configuration file under `/home/admin/mylabproject` to use the inventory file created in step 1 and to connect to remote hosts through the user (devops).

**Answer:**

Create `ansible.cfg` file:
```bash
cat > /home/admin/mylabproject/ansible.cfg << 'EOF'
[defaults]
inventory= /home/admin/mylabproject/inventory
remote_user= devops
host_key_checking= False
private_key_pass=Ansibles.pem
deprecation_warnings= False

[privilege_escalation]
become= True
become_method= sudo
become_user = root
become_ask_pass = False
EOF
```

**Configuration Breakdown:**

**[defaults] Section:**
- `inventory` - Path to your inventory file
- `remote_user` - Default SSH user for connections
- `host_key_checking` - Disable SSH key verification (lab environment only)
- `deprecation_warnings` - Suppress deprecation warnings

**[privilege_escalation] Section:**
- `become = True` - Enable privilege escalation by default
- `become_method = sudo` - Use sudo for privilege escalation
- `become_user = root` - Escalate to root user
- `become_ask_pass = False` - Don't prompt for sudo password

**Tips & Hints:**
- Always create `ansible.cfg` in your project directory for project-specific settings
- The config file should be in the same directory where you run ansible commands
- You can verify which config file is being used: `ansible --version`
- Config file priority: `ANSIBLE_CONFIG` env var → `./ansible.cfg` → `~/.ansible.cfg` → `/etc/ansible/ansible.cfg`

**Test Configuration:**
```bash
# Verify configuration is loaded
ansible --version

# Test connection
ansible production -m ping
```

---

### **Exercise 4: Configure Passwordless Sudo**

**Question:** Using Ansible, configure privilege escalation to use the root account with sudo without password authentication.

**Answer:**

**Method 1: Using Ad-hoc Command**
```bash
ansible production -m copy -a "content='devops ALL=(ALL) NOPASSWD: ALL\n' dest=/etc/sudoers.d/devops mode=0440" -b
```

**Method 2: Using Playbook (Recommended)**

Create `configure_sudo.yml`:
```yaml
---
- name: Configure passwordless sudo for devops user
  hosts: production
  become: yes
  tasks:
    - name: Create sudoers file for devops user
      copy:
        content: "devops ALL=(ALL) NOPASSWD: ALL\n"
        dest: /etc/sudoers.d/devops
        mode: '0440'
        validate: 'visudo -cf %s'
```

Run the playbook:
```bash
ansible-playbook configure_sudo.yml
```
Test the Syntax:
```bash
ansible-playbook configure_sudo --syntax-check
```

**Tips & Hints:**
- The sudoers file should have permissions `0440` (read-only for owner and group)
- Always use the `validate` parameter to check syntax before saving
- Place custom sudoers files in `/etc/sudoers.d/` directory
- File naming: avoid dots and special characters in filename
- The `\n` at the end of content is required for proper formatting
- Use `-b` for the ad-hoc command since you need root to modify sudoers

**Verify Configuration:**
```bash
# Test sudo without password
ansible production -m command -a "sudo -l" -u devops

# Test becoming root
ansible production -m command -a "whoami" -b -u devops
```

**Security Notes:**
- NOPASSWD should only be used in controlled environments
- In production, consider limiting commands: `devops ALL=(ALL) NOPASSWD: /specific/command`

---

### **Exercise 5: Configure Sudo on Production Group**

**Question:** Using Ansible, configure sudo configuration on the production group.

**Answer:**

**Option A: Using Copy Module (Ad-hoc)**
```bash
ansible production -m copy -a "content='%wheel ALL=(ALL) ALL\ndevops ALL=(ALL) NOPASSWD: ALL\n' dest=/etc/sudoers.d/production mode=0440 validate='visudo -cf %s'" -b
```

**Option B: Using Lineinfile Module (Ad-hoc)**
```bash
ansible production -m lineinfile -a "path=/etc/sudoers.d/devops line='devops ALL=(ALL) NOPASSWD: ALL' create=yes mode=0440 validate='visudo -cf %s'" -b
```

**Option C: Using Playbook (Best Practice)**

Create `production_sudo.yml`:
```yaml
---
- name: Configure sudo for production group
  hosts: production
  become: yes
  tasks:
    - name: Ensure sudoers.d directory exists
      file:
        path: /etc/sudoers.d
        state: directory
        mode: '0750'

    - name: Configure sudo for devops user
      copy:
        content: |
          # Sudo configuration for devops user
          devops ALL=(ALL) NOPASSWD: ALL
          
          # Allow wheel group
          %wheel ALL=(ALL) ALL
        dest: /etc/sudoers.d/production
        mode: '0440'
        validate: 'visudo -cf %s'
        
    - name: Ensure devops user is in wheel group
      user:
        name: devops
        groups: wheel
        append: yes
```

Run:
```bash
ansible-playbook production_sudo.yml
```

**Tips & Hints:**
- Always use `validate: 'visudo -cf %s'` to prevent syntax errors
- File permissions must be `0440` for sudoers files
- The `%` prefix indicates a group (e.g., `%wheel`)
- Use `append: yes` when adding users to groups to preserve existing groups
- Test after applying: `ansible production -m command -a "sudo -l" -u devops`

**Common Sudo Configurations:**
```bash
# Allow all commands without password
devops ALL=(ALL) NOPASSWD: ALL

# Allow specific commands only
devops ALL=(ALL) NOPASSWD: /usr/bin/systemctl, /usr/bin/yum

# Allow all commands with password
devops ALL=(ALL) ALL

# Allow group
%admin ALL=(ALL) ALL
```

**Verify:**
```bash
# Check sudo configuration
ansible production -m command -a "cat /etc/sudoers.d/production" -b

# Test sudo access
ansible production -m command -a "whoami" -b -u devops
```

---

### **Exercise 6: Debug Module - Print Custom Message**

**Question:** Using Ansible-doc, research the module debug to print a message named "My first debug msg!" after connecting to the production group.

**Answer:**

**Step 1: Research the Debug Module**
```bash
# View debug module documentation
ansible-doc debug

# Search for specific examples
ansible-doc debug | grep -A 5 "EXAMPLES"
```

**Step 2: Using Ad-hoc Command**
```bash
ansible production -m debug -a "msg='My first debug msg!'"
```

**Step 3: Using Playbook (Recommended)**

Create `debug_test.yml`:
```yaml
---
- name: Test debug module on production
  hosts: production
  tasks:
    - name: Print debug message
      debug:
        msg: "My first debug msg!"
```

Run:
```bash
ansible-playbook debug_test.yml
```

**Advanced Debug Examples:**

```yaml
---
- name: Advanced debug examples
  hosts: production
  tasks:
    - name: Simple message
      debug:
        msg: "My first debug msg!"
    
    - name: Debug with variable
      debug:
        msg: "Hostname is {{ ansible_hostname }}"
    
    - name: Debug with verbosity control (only shows with -v)
      debug:
        msg: "This is a verbose message"
        verbosity: 1
    
    - name: Debug variable content
      debug:
        var: ansible_facts
    
    - name: Debug multiple variables
      debug:
        msg: |
          Host: {{ inventory_hostname }}
          IP: {{ ansible_default_ipv4.address }}
          OS: {{ ansible_distribution }}
```

**Tips & Hints:**
- `ansible-doc <module_name>` shows detailed module documentation
- `ansible-doc -l` lists all available modules
- `ansible-doc -s <module_name>` shows module snippet/syntax
- Debug module is useful for troubleshooting playbooks
- Use `verbosity` parameter to control when messages appear (0-4)
- `msg` parameter prints a message
- `var` parameter prints variable contents
- Debug messages appear in green in the output

**Expected Output:**
```
managednode1 | SUCCESS => {
    "msg": "My first debug msg!"
}
managednode2 | SUCCESS => {
    "msg": "My first debug msg!"
}
```

**Additional Debug Techniques:**
```bash
# Run with increased verbosity
ansible-playbook debug_test.yml -v
ansible-playbook debug_test.yml -vv
ansible-playbook debug_test.yml -vvv

# Debug with filters
ansible production -m debug -a "msg={{ inventory_hostname | upper }}"
```

---

## Quick Reference Commands

### Inventory Management
```bash
# List all hosts
ansible all --list-hosts

# List specific group
ansible production --list-hosts

# List host variables
ansible production -m debug -a "var=hostvars[inventory_hostname]"

# Check inventory graph
ansible-inventory --graph
```

### Ad-hoc Commands
```bash
# Ping all hosts
ansible all -m ping

# Check connectivity
ansible production -m command -a "uptime"

# Gather facts
ansible production -m setup

# Copy file
ansible production -m copy -a "src=/path/to/file dest=/tmp/"
```

### Playbook Commands
```bash
# Run playbook
ansible-playbook playbook.yml

# Dry run (check mode)
ansible-playbook playbook.yml --check

# Run with verbosity
ansible-playbook playbook.yml -v

# Run specific tags
ansible-playbook playbook.yml --tags "configuration"

# List tasks
ansible-playbook playbook.yml --list-tasks
```

### Documentation
```bash
# List all modules
ansible-doc -l

# View module documentation
ansible-doc <module_name>

# View module snippet
ansible-doc -s <module_name>

# Search modules
ansible-doc -l | grep user
```

---

## Troubleshooting Tips

### Common Issues and Solutions

**1. SSH Connection Issues**
```bash
# Test SSH manually
ssh -i ~/.ssh/id_rsa devops@<host_ip>

# Test with ansible
ansible production -m ping -vvv

# Add SSH key to known_hosts
ssh-keyscan <host_ip> >> ~/.ssh/known_hosts
```

**2. Permission Denied**
```bash
# Ensure you're using -b for privilege escalation
ansible production -m command -a "whoami" -b

# Check sudo configuration
ansible production -m command -a "sudo -l" -u devops
```

**3. Inventory Not Found**
```bash
# Verify inventory path
ansible-inventory --list

# Specify inventory explicitly
ansible all -i /path/to/inventory --list-hosts
```

**4. Module Not Found**
```bash
# Verify module exists
ansible-doc <module_name>

# Use fully qualified collection name
ansible production -m ansible.builtin.user
```

---

## Best Practices

1. **Always use version control** - Track your playbooks and inventory in Git
2. **Use meaningful names** - Name hosts, groups, and playbooks descriptively
3. **Document your code** - Add comments and use debug messages
4. **Test before production** - Use `--check` mode and test on dev environments first
5. **Use variables** - Don't hardcode values, use variables and group_vars
6. **Idempotency** - Ensure tasks can run multiple times safely
7. **Use roles** - Organize complex playbooks into reusable roles
8. **Encrypt sensitive data** - Use ansible-vault for passwords and keys
9. **Use tags** - Tag tasks for selective execution
10. **Handle errors** - Use error handling with `ignore_errors`, `failed_when`, `block/rescue`

---

## Additional Resources

- [Ansible Official Documentation](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/) - Community roles and collections
- [Ansible GitHub](https://github.com/ansible/ansible)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

---

## Project Structure (Recommended)

```
mylabproject/
├── ansible.cfg
├── inventory
├── group_vars/
│   ├── production.yml
│   ├── DR.yml
│   └── all.yml
├── host_vars/
│   ├── managednode1.yml
│   └── managednode2.yml
├── playbooks/
│   ├── configure_sudo.yml
│   ├── create_users.yml
│   └── debug_test.yml
├── roles/
│   └── common/
│       ├── tasks/
│       ├── handlers/
│       ├── templates/
│       └── vars/
└── README.md
```

---

**Good luck with your Ansible training! 🚀**
