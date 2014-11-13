## Get the Bone in the internet

This will tell you how to connect the beaglebone to the internet.
There are three possibilies how to achieve that goal

### 1. Easy

1. Connect an ethernet cable with your bone and the other end with your router.

2. You're done.

### 2. There is only WIFI or It's not that easy
 
Requirements: 
Computer which can connect to the WIFI and with a free Ethernet Port
Ethernet Cable

1. On the host computer (the computer whose Internet connection you plan to share) open Network Connections by clicking the Start button Picture of the Start button, and then clicking Control Panel. In the search box, type adapter, and then, under Network and Sharing Center, click View network connections.
	
2. Select your WIFI and your LAN adapter by holding CTRL and clicking on both.

3. Right click on the second and choose "Bridge Connection"

4. Connect an Ethernet cable with your bone and the other end with your router.

5. You're done
	
### 3. Why should I use another cable?

1. Connect to your bone via SSH

2. Enter the following:
	```bash
	ifconfig usb0 192.168.7.2
	route add default gw 192.168.7.1
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
	```
3. On your computer:
	running Linux: 
	
	```bash
	sudo su
	#eth0 is my internet facing interface, eth3 is the BeagleBone USB connection
	ifconfig eth3 192.168.7.1
	iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
	iptables --append FORWARD --in-interface eth3 -j ACCEPT
	echo 1 > /proc/sys/net/ipv4/ip_forward
	```
	
	running Windows:
	follow this Tutorial: 
	http://windows.microsoft.com/en-us/windows/set-internet-connection-sharing#1TC=windows-7
	 
	change the IP-Adress of your USB-Networkadapter to the old "172.168.7.1"
	
	
4. You're done
	
