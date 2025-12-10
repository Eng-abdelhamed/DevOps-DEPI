# Linux & GNU Complete Notes (Single File)

## Useful Links
https://bellard.org/jslinux/
https://git.kernel.org/
https://kernel.org/
https://www.gnu.org/
https://www.gnu.org/software/software.html

================================================================================

## GRUB2
GRUB2 is a bootloader for GNU/Linux operating systems  
GRUB2 files location: /boot/grub/

================================================================================

## Linux Boot Process
1- BIOS  
2- MBR  
3- Boot Loader (GRUB2)  
4- Load Kernel into memory  
5- Init or systemd  
6- Runlevel & services  
7- Login  
8- Desktop  

================================================================================

## Shell Types
bash  
ksh  
csh  
zsh  
tcsh  

================================================================================

## GUI Types
GNOME  
KDE  
Unity  

================================================================================

## uname Command
uname        -> system info  
uname -a     -> all info  
uname -m     -> machine  
uname -n     -> nodename  
uname -r     -> kernel release  
uname -s     -> OS name  
uname -v     -> OS version  

================================================================================

## ls Command
ls  
ls /home/user/dir1  
ls -a  
ls -l  
ls -R  

-rw-r--r-- 1 islam islam 20 May 21 16:11 omar.txt  
Permissions | Links | Owner | Group | Size | Date | Name  

================================================================================

## Wildcards
ls f*  
ls .*  
ls *m  
ls file?  
ls ???  
ls ?a?  
ls ?a*  
ls *a*  
ls file[a-f]  
ls [a-f]*  
ls [a-zA-Z]*  
ls [pf]*  
ls [ab]m  

================================================================================

## Users and Groups

### User Management
useradd omar  
useradd -m omar  
useradd -md /home/user1 omar  
useradd -u 1000 -g 1000 -c "New user" -md /home/user1 -s /bin/bash omar  

### Usermod
usermod -aG Developer omar  
usermod -l omar1 omar  
usermod -L omar  
usermod -U omar  

### Delete User
userdel omar  
userdel -r omar  

================================================================================

## Password Management
passwd omar  
chage -m 10 omar  
chage -M 10 omar  
chage -E 10 omar  
chage -W 10 omar  

================================================================================

## Groups
groupadd group1  
groupadd -g 1000 -c "New group" group1  
groupmod -n group2 group1  
groupdel group1  

gpasswd -A omar group1  
gpasswd -d omar group1  

================================================================================

## Ownership & Permissions

### Ownership
chown omar file.txt  
chown :Administrator file.txt  
chown omar:Administrator file.txt  
chgrp Administrator file.txt  

### Permissions
chmod o-r file.txt  
chmod g-w file.txt  
chmod u+x,go+r file.txt  
chmod 777 file.txt  
chmod 000 file.txt  

================================================================================

## umask
umask 000  
umask 002  
umask 137  

================================================================================

## Shutdown
init 0  
poweroff  
shutdown -h now  
shutdown -h +1  
shutdown -k now  

## Reboot
init 6  
reboot  
shutdown -r now  
shutdown -r +1  

================================================================================

## User Info
whoami  
w  
pwd  
groups  
id  

================================================================================

## Important Files
/etc/passwd  
/etc/shadow  
/etc/group  
/etc/gshadow  
~/.profile  
~/.bashrc  

================================================================================

## sudoers
visudo  

User_Alias DEV = omar  
Host_Alias SERVERS = server1, server2  
Cmnd_Alias REBOOT = /sbin/reboot  

omar ALL=(ALL) ALL  
omar ALL=(ALL) NOPASSWD: ALL  
omar ALL=(ALL) NOPASSWD: /bin/ls  

================================================================================

## VI / VIM
i a o O  
h j k l  
yy dd p P  
:w :q :wq :q!  
:set nu  
/omar  
:%s/omar/ahmed/g  

================================================================================

## Variables
name=omar  
echo $name  
typeset -i x  
x=5+5  
((z=x+5))  

### Concatenation
z="$x ahmed"  

================================================================================

## Environment Variables
env  
printenv  
set  
export name  

$HOME  
$SHELL  
$PS1  
$PWD  
$USER  
$HOSTNAME  
$PATH  

================================================================================

## Alias
alias c=clear  
unalias c  

================================================================================

## History
!!  
!ls  
!5  

================================================================================
