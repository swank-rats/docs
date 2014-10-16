# Installation

In this chapter is described how to install the environment to run the software. 

## Beaglebone

To run the control-software for the robot you have to install:
 
* WIFI (TP-Link TL-WN725N)
* ...

### WIFI (TP-Link TL-WN725N)

This tutorial is inspired by: http://brilliantlyeasy.com/ubuntu-linux-tl-wn725n-tp-link-version-2-wifi-driver-install/

Important: Run in __root__

1. Install Kernel-Sources

```bash
apt-get update
apt-get install linux-headers-$(uname -r)
```

2. Install dependencies

```bash
apt-get update
apt-get install build-essential git 
```

3. Build driver

```bash
git clone https://github.com/lwfinger/rtl8188eu
cd rtl8188eu
make all
make install
insmod 8188eu.ko
```

4. Check installation

```bash
ifconfig
```

5. Reboot

```bash
rebot
```

6. Install and Configure WPA-Supplicant

```bash
aptget install wpasupplicant
wpa_passphrase <ssid> <password> > /etc/wpa.config
```

7. Add config to start script: App following to config file `/etc/network/interfaces`

```
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa.config
```
