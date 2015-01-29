
# Appendix

## Get the Beagle Bone into the Internet

In this section we will tell you how to connect a beaglebone to the Internet.
There are three possibilities how to achieve this goal.

### Via lan (easy)

1. Connect an ethernet cable with your beagle bone and the other end with your router.
2. You're done.

### Via a bridged wireless lan (not that easy)
 
__Requirements:__ 
* a computer which is connected via WIFI to the Internet 
* a free Ethernet Port and a ethernet cable

1. On the host computer (the computer whose Internet connection you plan to share) open the network connections by navigating to the controll panel. In the search box, type adapter, and then, under Network and Sharing Center, click View network connections.	
2. Select your WIFI and your LAN adapter by holding CTRL and clicking on both.
3. Right click on the second and choose "Bridge Connection"
4. Connect an ethernet cable with your beagle bone and the other end with your computer.
5. You're done

### Via Eduroam wireless lan (not easy at all)

__Step 0__
```bash
apt-get install wpasupplicant
```

__Step 1__

* Login as root
* Create a file `/etc/wpa_supplicant/wpa_supplicant.conf`
* Type the following parameters:

```
ctrl_interface=/var/run/wpa_supplicant
network={
   scan_ssid=1
   ssid="eduroam"
   key_mgmt=WPA-EAP
   eap=PEAP
   identity="xyz1234@students.fhv.at"
   password="XXXXXX"
   ca_cert="/etc/ssl/certs/AddTrust_Extern_Root.pem"
   phase1="peaplabel=0"
   phase2="auth=MSCHAPV2"
}
```

__Step 2__

Run the command:

```bash
wpa_supplicant -i $WLAN -D wext -c /etc/wpa_supplicant/wpa_supplicant.conf&
```

__Note:__

* Instead of $WLAN type your interface name.
* To view the name type iwconfig
* Wait until the authentication has been finished.
* To receive an IP address type: dhclient

To view if you are connected type:

```bash
ifconfig -a
```

__Or use script from FHV__

Download it from: [https://inside.fhv.at/pages/viewpage.action?pageId=54198344](https://inside.fhv.at/pages/viewpage.action?pageId=54198344)

```bash
chmod +x eduroam-linux-Fachhochschule_Vorarlberg.sh
./eduroam-linux-Fachhochschule_Vorarlberg.sh
wpa_supplicant -i wlan0 -D wext -c /root/.eduroam/eduroam.conf&
```

### Via usb cable

This method creates a default route on the beaglebone which can cause errors with other networks!
Try an other solution first!

1. Connect to your bone via SSH
2. Enter the following:
	```bash
	ifconfig usb0 192.168.7.2
	route add default gw 192.168.7.1
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
	```
3. On your computer:
  * running Linux:
```bash
sudo su
#eth0 is my internet facing interface, eth3 is the BeagleBone USB connection
ifconfig eth3 192.168.7.1
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --append FORWARD --in-interface eth3 -j ACCEPT
echo 1 > /proc/sys/net/ipv4/ip_forward
```
	* running Windows: follow this [Tutorial](http://windows.microsoft.com/en-us/windows/set-internet-connection-sharing#1TC=windows-7) change the IP adress of your USB-Networkadapter to the old "172.168.7.1"
4. You're done

## Reflash BBB

* [Download Image (that works with WLAN-Dongle)](http://debian.beagleboard.org/images/BBB-eMMC-flasher-debian-7.4-2014-04-23-2gb.img.xz).
* Follow this instructions to copy image to an SD-Card.
* Insert SD-Card when BBB is unplugged
* Press following button and plugin BBB with a smartphone-charger (more power than PC)

![Boot-Switch button](appendix/img/flash-button.jpeg)

* Keep holding down the button until you see the bank of 4 LED's light up for a few seconds. You can now release the button.
* Wait about 25-45min while the BBB will be flashed
* Once it's done, the bank of 4 LED's to the right of the Ethernet will all stay lit up at the same time. You can then power down your BeagleBone Black and remove SD-Card.

The appropriate linux-headers can be found [here](http://rcn-ee.net/deb/wheezy-armhf/v3.8.13-bone47/linux-headers-3.8.13-bone47_1.0wheezy_armhf.deb).

Detailed information can be found [here](https://learn.adafruit.com/beaglebone-black-installing-operating-systems/overview).
