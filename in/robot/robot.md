
# Roboter

The meeple is a real robot which moves in the real world pitch. It is controlled by a person on the browser. In this
chapter this robot will be described in more detail.

## Hardware

The robot hardware is a composition of several parts:

* [BeagleBoneBlack](http://beagleboard.org/Products/BeagleBone+Black): is the control unit of the robot. It communicate
  with the server and controls the wheels and motors. The software for this board is written in Phyton which provides a
  library to communicate with the Common IO of the main board. To connect with the LAN the board uses a WLAN-Dongle.
  
![BeagleBoneBlack from above](robot/img/bbb)
  
* [Chasis](http://www.robotshop.com/eu/en/dfrobot-2wd-mobile-platform-arduino.html): The chassis is a round robot which
  is powered by two electric motor and two wheels, which provides to corner sharply.
  
![Chassis example picture](robot/img/chasis)

* Engergy supply: For the energy supply we use 8 (TODO ???) batteries which provides directly the power for the motor
  and supply the BeagleBone with 5V, over a [POWER SUPPLY CAPE](http://at.farnell.com/circuitco/power-supply-cape-for-bbb/power-supply-cape-beaglebone-board/dp/2399909). 
  
## Specification

* TODO bbb
* TODO motor

## Energy consumption

* TODO energy consumption
