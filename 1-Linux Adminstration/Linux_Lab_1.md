# Lab 1: The Linux Terminal and Manual

1. **How to display the current date and time?**  
```
date
```
---

2. **Display the current day of the year using the `date` command.**  
```
date +%j
```
---

3. **Display the current time using the 24:00 hour format.**  
```
date +%R
```
---

4. **Display the file `/etc/passwd`.**  
```
cat /etc/passwd
less /etc/passwd
more /etc/passwd
```
---

5. **Display the last 10 lines of the `/etc/group` file.**  
```
tail -n 10 /etc/group
```
---

6. **Repeat the previous command with the help of the `history` command.**  

**Option 1:** Reverse search  
```
Ctrl + r
```

**Option 2:** Using history number  
```
history
!<number>
```
---

7. **Display the first 4 lines of the file `/etc/group`.**  
```
head -n 4 /etc/group
```
---

8. **Use the Linux manual to check the content of the `man` command.  
   What is the option to use to find the location of the manual page of the `passwd` command?**

Check man command:
```
man man
```

Find manual page location:
```
man -w passwd
```
---

9. **Check the `cat` command using the man pages and search for the option to use to number the output file of `/etc/passwd`.**  
```
cat -n /etc/passwd
```
