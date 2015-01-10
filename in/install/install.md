
# Installation

In this chapter is described how to install the environment to run the software. 

## Beaglebone

To run the control-software for the robot you have to install:
 
* WIFI (TP-Link TL-WN725N)
* Phyton

### WIFI (TP-Link TL-WN725N)

This tutorial is inspired by: http://brilliantlyeasy.com/ubuntu-linux-tl-wn725n-tp-link-version-2-wifi-driver-install/

Important: Run in __root__

1. Install Kernel-Sources

```bash
apt-get update
apt-get install linux-headers-$(uname -r)
```

If the linux-header version does not exists search for deb file in http://rcn-ee.net/deb/precise-armhf.

__Example:__

```bash
wget http://rcn-ee.net/deb/trusty-armhf/v$(uname -r)/linux-headers-$(uname -r)_1.0trusty_armhf.deb
dpkg -i linux-headers-$(uname -r)_1.0trusty_armhf.deb
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
iwconfig
```

5. Reboot

```bash
reboot
```

6. Install and Configure WPA-Supplicant

```bash
apt-get install wpasupplicant
wpa_passphrase <ssid> <password> > /etc/wpa.config
```



7. Add config to start script: App following to config file `/etc/network/interfaces`

```
auto wlan0
iface wlan0 inet dhcp
    wpa-conf /etc/wpa.config
```

### Phyton

```bash
apt-get install python
apt-get install python3
cat > hello.py << EOF
#!/usr/bin/env python3
# Mein Hallo-Welt-Programm fuer Python 3
print('Hallo Welt!')
EOF
python hello.py
chmod u+x hello.py
./hello.py
```

### DMCC Library

Library to control the motor-cape.

```bash
git clone git://github.com/Exadler/DMCC_Library
cd DMCC_Library/
make
python setupDMCC.py install
```

### WS4PY

Library to communicate over Websocket.

```bash
php install ws4py
```

### Troubleshooting

1. ERROR: `mach/timex.h: No such file or directory`
```bash
cd usr/src/linux-headers-$(uname -r)/arch/arm/include
mkdir mach
touch mach/timex.h
```
source: [https://groups.google.com/forum/#!msg/beagleboard/1IkTdkdUCLg/8th83TmgdPkJ](https://groups.google.com/forum/#!msg/beagleboard/1IkTdkdUCLg/8th83TmgdPkJ)

2. WARNING: `perl: warning: Setting locale failed.`
```bash
sudo locale-gen de_AT.UTF-8
```
source: [http://stackoverflow.com/questions/2499794/how-can-i-fix-a-locale-warning-from-perl](http://stackoverflow.com/questions/2499794/how-can-i-fix-a-locale-warning-from-perl)
