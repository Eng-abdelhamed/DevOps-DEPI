#!/bin/bash



#touch /home/ec2-user/host_vars/host_info/managednode1
#touch /home/ec2-user/host_vars/host_info/managednode2
for i in managednode1 managednode2;
do
	ansible $i -m setup -a 'filter=devices' > host_vars/$i.facts
	
	ansible $i -m setup -a 'filter=enp0s3' >> host_vars/$i.facts
done;
echo "Done Success";
