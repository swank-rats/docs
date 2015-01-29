
# Installation

In this chapter is described how to install the environment to run the software. 

## Installation of mean.io and game-server

### Prerequisites
To get started with the [mean stack](http://mean.io/) we need to install Node.js and MongoDB.

#### Node.js
Get the appropriate installer for [Node.js](http://nodejs.org/) for your OS on their website or just use your favourite package manager. After the installation you should get something like this when you type ```node --version``` and ```npm --version``` on your commandline:

![commandline node and npm](https://raw.githubusercontent.com/swank-rats/game-logic/master/documentation/images/node_npm.png)

#### MongoDB
To install [MongoDB](http://docs.mongodb.org) follow this [link](http://www.mongodb.org/downloads) and get a installer or use your package manager again. After the installation create the following directory structure ```data\db``` in the MongoDB installation directory.

###### Windows
To start MongoDB on __Windows__ just execute the following exe-file (from the commandline to see possible error messages):
```
~MongoDBDirectory\bin\mongod.exe
```
add the dbpath-parameter to the command when you did not install MongoDB in the default location:
```
~MongoDBDirectory\bin\mongod.exe --dbpath "d:\path\to\data\db"

```
When the mongod.exe launch was successfull you should be able execute the mongo.exe to start working with MongoDB.

###### Ubuntu
To start MongoDB on __Ubuntu__ type following on your cli:
```
sudo service mongod start
```

###### Mac
To start MongoDB on __Mac__ type following on your cli:
```
mongod
```
  
##### More details on the installation process
This guide is just a short summery of the installation process - when you need more details just follow this [link](http://docs.mongodb.org/manual/installation/) and you will find a lot of information for Windows, Mac and Linux.

##### Security

To enforce security please follow the the steps described [here](http://docs.mongodb.org/manual/security/) because ...
> __Warning:__
> MongoDB is designed to be run in trusted environments, and the database does not enable “Secure Mode” by default.
 

### Installation
When Node.js and MongoDB are installed we install bower and grunt with following command:
```
npm install -g bower grunt-cli
```
[Bower](http://bower.io/) is a package manager for Javascript libraries like e.g. jQuery and will help us to get all dependencies with just one command and [Grunt](http://gruntjs.com/) is a taskrunner and will be used to build the files for the application (Javascript / CSS / etc.) and also to run the server. 

These are the basic requirements for this repository to work - if you need more information about the mean stack take a look at [https://github.com/linnovate/mean](https://github.com/linnovate/mean).

### Start the app
After these steps the basic requirements for this application are installed and you can clone the repository and execute
```
clone git@github.com:swank-rats/game-logic.git
cd game-logic
npm install
grunt
```
in the repository directory. You should see the project at ```http://localhost:3000```


### IDE integration
For a very cool integration into Webstorm or Intellij IDEA from Jetbrains watch this [tutorial on youtube](https://www.youtube.com/watch?v=JnMvok0Yks8).

__In short:__
- add mongoose, angular and express Settings > Javascript > Libraries > Download from the "TypeScript community stubs"-list in the dropdown
- add mongo plugin to explore MongoDB in the IDE
- add a configuration for remote debugging of node.js and enter the host with the port - 5858 in our case


## Beaglebone

To run the control-software for the robot you have to install:
 
* WIFI (TP-Link TL-WN725N)
* Phyton

### WIFI (TP-Link TL-WN725N)

This tutorial is inspired by: [http://brilliantlyeasy.com/ubuntu-linux-tl-wn725n-tp-link-version-2-wifi-driver-install/](http://brilliantlyeasy.com/ubuntu-linux-tl-wn725n-tp-link-version-2-wifi-driver-install/)

Important: Run in __root__

1. Install Kernel-Sources

```bash
apt-get update
apt-get install linux-headers-$(uname -r)
```

If the linux-header version does not exists search for deb file in [http://rcn-ee.net/deb/precise-armhf](http://rcn-ee.net/deb/precise-armhf).

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

6. Install and configure WPA-Supplicant

```bash
apt-get install wpasupplicant
wpa_passphrase <ssid> <password> > /etc/wpa.config
```



7. Add config to start script: Add following to config file `/etc/network/interfaces`

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
cd DMCC_Librahttp://rcn-ee.net/deb/precise-armhfry/
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

### Install OpenSSL

  1. Download [OpenSSL Installer for Windows](https://slproweb.com/products/Win32OpenSSL.html)
  2. Run installer
  3. Add a new system environment variable. To do so open Control Panel -> System -> Advanced system settings -> Environment variables.
  4. At system variables press the "new" button and add a variable with name "OPENSSL" and path to e.g. "C:/OpenSSL/" (or to your new location) (with "/" at the end!)
  5. OpenSSL installation is finished

 ### Install Poco C++ Libraries
 
  1. Download [Poco C++ Libraries 1.5.4 (development version) all](http://pocoproject.org/download/index.html) - [direct link - download poco-1.5.4-all.zip](http://pocoproject.org/releases/poco-1.5.4/)
  2. Unpack the archive file to e.g. C:/Poco
  3. Navigate to the folder
  4. Open the file "components" and remove "CppUnit", "Data", "Data/SQLite", "Data/ODBC", "Data/MySQL", "Zip"
  5. You have to edit the path to your OpenSSL installation in the file "buildwin.cmd", if it is not "C:/OpenSSL"
  6. Double click build_vs120.cmd -> this command will build the needed files
  7. Make sure that the folder e.g."C:/Poco" contains a folder "bin" and "lib".
  8. Again add a new system environment variable.
  9. At system variables press the "new" button and add a variable with name "POCO" and path to "C:/Poco/" (or to your new location) (with "/" at the end!)
  10. Edit the variable PATH
  11. Add "C:/Poco/bin" at the end (between the last and the new entry must be a ";"!)
  12. Poco installation is finished.
  
### Install OpenCV

  1. Download [OpenCV 2.4.9](http://opencv.org/)
  2. Unpack the archive file
  3. Copy all the files to the location where you want it to have on your compute
  4. OpenCV is already delivered with prebuild VS120 libs. So we have nothing to build.
  5. Again add a new system environment variable. To do so open Control Panel -> System -> Advanced system settings -> Environment variables.
  6. At system variables press the "new" button and add a variable with name "OPENCV" and path to e.g. "C:/opencv/build/" (with "/" at the end!). This is the path to the OpenCV installation including the folder "build". The folder "build" must contain the folder "include" and "x86/vc12/lib".
  7. Modify the PATH variable. Add "%OPENCV%/x86/vc12/bin;" (without ") at the end of the value of your PATH variable.
  8. OpenCV installation is finished.,
3. Clone this repository
4. Open the solution with VS 2013
5. Build the project
6. Click right on the solution and go to -> properties -> debugging -> additional command line parameters
7. add /uri=ws://127.0.0.1:3001/ where the IP and port should be the address of the NodeJS server
6. Finish - now you can run the application!

### Troubleshooting

 * [OpenCV: install instructions windows](http://docs.opencv.org/doc/tutorials/introduction/windows_install/windows_install.html#windows-installation)
 * [OpenCV: instruction for setting up the environment variables](http://docs.opencv.org/doc/tutorials/introduction/windows_install/windows_install.html#windowssetpathandenviromentvariable)
 * [OpenCV: general install instructions](http://docs.opencv.org/doc/tutorials/introduction/table_of_content_introduction/table_of_content_introduction.html)
 * [OpenCV: Installing & Configuring OpenCV with Visual Studio](http://opencv-srf.blogspot.co.at/2013/05/installing-configuring-opencv-with-vs.html)
 * [Poco: Building On Windows](http://pocoproject.org/docs/00200-GettingStarted.html#7)

### Build & Start application

1. Open the solution with VS 2013
2. Right click on the solution image-processing -> Properties
3. Now navigate to Configuration properties -> Debugging -> Command line arguments
4. Enter /uri=wss://IP:3001/ (replace the IP with the IP of your game server)
5. Build it
6. Run it

When you run the .exe manually do not forget to pass the /uri parameter. 

```
//to get help:
image-processing.exe /help

//to start the image processing server (important use wss and add a "/" at the end!)
image-processing.exe /uri=wss://127.0.0.1:3001/
```
