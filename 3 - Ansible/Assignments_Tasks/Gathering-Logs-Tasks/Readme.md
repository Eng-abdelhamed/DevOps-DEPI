# Log Collection and Rsyslog Configuration Lab

## Overview

This lab covers two main tasks:

1. Creating an Ansible playbook to gather secure logs from production hosts.
2. Configuring `rsyslog` on a managed node using a single ad-hoc command and verifying the configuration.

---

## Task 1: Ansible Playbook – `gather-securelogs.yml`

### Objective

Create an Ansible playbook named **`gather-securelogs.yml`** that:

* Collects `/var/log/secure` log files
* Targets all hosts under the **`production`** inventory group
* Stores the collected logs on the control node under:

```
/home/admin/mylabproject/Remotelogs
```

### Expected Behavior

* Logs should be fetched from each managed host in the `production` group
* Logs should be organized clearly on the control node (for example, by hostname)

---

## Task 2: Rsyslog Configuration Using Ad-Hoc Command

### Target Host

* **`managednode2`**

### Objective

Using a **single Ansible ad-hoc command**, configure `rsyslog` so that:

* Any log messages from the **`authpriv`** facility
* With priority **`alert` and higher**
* Are stored in the following file:

```
/var/log/mylogs/alert-secure
```

### Requirements

* The configuration must be applied using **one ad-hoc command only**
* No playbooks should be used for this step

---

## Verification

After configuring `rsyslog`, verify the setup using Ansible ad-hoc commands by:

* Checking that the configuration file was created or updated correctly
* Confirming that log entries matching the criteria are written to:

```
/var/log/mylogs/alert-secure
```

---

## Notes

* Ensure `rsyslog` is running and enabled after configuration changes
* Use appropriate privileges (e.g., `become: true`) where required
* Follow best practices for log management and permissions

---

Completion of this lab demonstrates proficiency with Ansible playbooks, ad-hoc commands, and centralized log handling.

---

## Task 3: Welcome Message Playbook – `welcomemessage.yml`

### Objective

Develop an Ansible playbook named **`welcomemessage.yml`** that runs on the **`production`** group and displays a welcome message after SSH authentication.

### Requirements

The welcome message must:

* Be displayed **after SSH login**
* Include the **current system owner**
* Provide a support contact email for issues:

```
support@xyz.com
```

### Hint

* Use the `/etc/motd` file to configure the login message

### Expected Outcome

* Users logging in via SSH to any host in the `production` group should see the customized welcome message
* The message should clearly identify the system owner and support contact

---

Completion of this task demonstrates understanding of system login messages and Ansible-based configuration management.
