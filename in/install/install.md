
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

### Supervisor

```bash
apt-get install supervisor
cp roboter-software/SwankRatsRoboterSoftware/swank-rats.conf /etc/supervisor/conf.d
service supervisor restart

cat > /etc/supervisor/supervisord.conf <<EOF
[inet_http_server]
port = 9001
username = admin
password = admin
EOF
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

## Open CV and POCO for image server

To get this project running you need [OpenCV 2.4.9](http://opencv.org/) and [Poco C++ Libraries 1.5.4](http://pocoproject.org/). We developed on Windows 7 by using Visual Studio 2013 as IDE and the Microsoft Visual C++ Compiler 18.00.21005.1 for x86 platform. The installation instructions are for Visual Studio 2013 and Windows.

It is necessary to add new system environment variables. So do not close the window, if you have opened it during the installation process.

1. Install OpenSSL
  1. Download [OpenSSL Installer for Windows](https://slproweb.com/products/Win32OpenSSL.html)
  2. Run installer
  3. Add a new system environment variable. To do so open Control Panel -> System -> Advanced system settings -> Environment variables.
  4. At system variables press the "new" button and add a variable with name "OPENSSL" and path to e.g. "C:\OpenSSL\" (or to your new location) (with "\" at the end!)
  5. OpenSSL installation is finished
2. Install Poco C++ Libraries
  1. Download [Poco C++ Libraries 1.5.4 (development version) all](http://pocoproject.org/download/index.html) - [direct link - download poco-1.5.4-all.zip](http://pocoproject.org/releases/poco-1.5.4/)
  2. Unpack the archive file to e.g. C:\Poco
  3. Navigate to the folder
  4. Open the file "components" and remove "CppUnit", "Data", "Data/SQLite", "Data/ODBC", "Data/MySQL", "Zip"
  5. You have to edit the path to your OpenSSL installation in the file "buildwin.cmd", if it is not "C:\OpenSSL"
  6. Double click build_vs120.cmd -> this command will build the needed files
  7. Make sure that the folder e.g."C:\Poco" contains a folder "bin" and "lib".
  8. Again add a new system environment variable.
  9. At system variables press the "new" button and add a variable with name "POCO" and path to "C:\Poco\" (or to your new location) (with "\" at the end!)
  10. Edit the variable PATH
  11. Add "C:\Poco\bin" at the end (between the last and the new entry must be a ";"!)
  12. Poco installation is finished.
2. Install OpenCV
  1. Download [OpenCV 2.4.9](http://opencv.org/)
  2. Unpack the archive file
  3. Copy all the files to the location where you want it to have on your compute
  4. OpenCV is already delivered with prebuild VS120 libs. So we have nothing to build.
  5. Again add a new system environment variable. To do so open Control Panel -> System -> Advanced system settings -> Environment variables.
  6. At system variables press the "new" button and add a variable with name "OPENCV" and path to e.g. "C:\opencv\build\" (with "\" at the end!). This is the path to the OpenCV installation including the folder "build". The folder "build" must contain the folder "include" and "x86\vc12\lib".
  7. Modify the PATH variable. Add "%OPENCV%\x86\vc12\bin;" (without ") at the end of the value of your PATH variable.
  8. OpenCV installation is finished.,
3. Clone this repository
4. Open the solution with VS 2013
5. Build the project
6. Click right on the solution and go to -> properties -> debugging -> additional command line parameters
7. add /uri=ws://127.0.0.1:3001/ where the IP and port should be the address of the NodeJS server
6. Finish - now you can run the application!

__Troubleshooting__

  * [OpenCV: install instructions windows](http://docs.opencv.org/doc/tutorials/introduction/windows_install/windows_install.html#windows-installation)
  * [OpenCV: instruction for setting up the environment variables](http://docs.opencv.org/doc/tutorials/introduction/windows_install/windows_install.html#windowssetpathandenviromentvariable)
  * [OpenCV: general install instructions](http://docs.opencv.org/doc/tutorials/introduction/table_of_content_introduction/table_of_content_introduction.html)
  * [OpenCV: Installing & Configuring OpenCV with Visual Studio](http://opencv-srf.blogspot.co.at/2013/05/installing-configuring-opencv-with-vs.html)
  * [Poco: Building On Windows](http://pocoproject.org/docs/00200-GettingStarted.html#7)
