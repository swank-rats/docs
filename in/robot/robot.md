
# Roboter

The meeple is a real robot which moves in the real world pitch. It is controlled by a person on the browser. In this
chapter this robot will be described in more detail.

![Robot](robot/img/robot.jpg)

## Hardware

The robot hardware is a composition of several parts:

* [BeagleBoneBlack](http://beagleboard.org/Products/BeagleBone+Black): is the control unit of the robot. It communicate
  with the server and controls the wheels and motors. The software for this board is written in Phyton which provides a
  library to communicate with the Common IO of the main board. To connect with the LAN the board uses a WLAN-Dongle.
  
![BeagleBoneBlack from above](robot/img/bbb.jpg)
  
* [Chassis](http://www.robotshop.com/eu/en/dfrobot-2wd-mobile-platform-arduino.html): The chassis is a round robot which
  is powered by two electric motor and two wheels, which provides to corner sharply.
  
![Chassis example picture bottom](robot/img/chassis)

![Chassis example picture top](robot/img/chassis_top)

* Engergy supply: For the energy supply we use 5 batteries which provides directly the power for the motor
  and supply the BeagleBone with 4 Batteries (for example 5V).

* [MotorControllerCape](https://github.com/Exadler/DualMotorControlCape): Expands the board with the ability to control
  motors over a simple library.

## Specification

* BeagleBone Black is a low-cost, community-supported development platform for developers and hobbyists.
    Spetzifikations:
  - Am335x 1GHz ARM Cortex-A8 Prozessor
  - 12MB RAM
  - 4GB Onboard eMMC Flash Speicher

* Motor ![Motor Picture](robot/img/0467-900x600.jpg)
  - Operating Voltage Range: 3~7.5V
  - Rated Voltage: 6V
  - Max. No-load Current(3V): 140 mA
  - Max. No-load Current(6V): 170 mA
  - No-load Speed(3V): 90 rpm
  - No-load Speed(6V): 160 rpm
  - Max. Output Torque: 0.8 kgf.cm
  - Max. Stall Current: 2.8 A

It can be ordered [here](http://www.dfrobot.com/index.php?route=product/product&path=47&product_id=100).

## Schema

![Schematics](robot/img/SwankRatsSchematics)

## Energy consumption

### BeagleBone Black

We measured 300mA current at 5V energy consumption. During booting it went up to 500mA Peak. 

### Motors

The library DMCC provides a little tool to monitor the current consumption of the linked motors.

This output was produced when the robot drives with 40% which the highest possible level without exceed the current
limiter of the motor control cape.

```bash
$ root@beaglebone:~/DMCC_Library# ./getCurrent 0
Current Motor 1 = 81 (0x51), Motor 2 = 71 (0x47), Voltage = 6322 (0x18b2)
Current Motor 1 = 64 (0x40), Motor 2 = 70 (0x46), Voltage = 6259 (0x1873)
Current Motor 1 = 73 (0x49), Motor 2 = 73 (0x49), Voltage = 6277 (0x1885)
Current Motor 1 = 65 (0x41), Motor 2 = 69 (0x45), Voltage = 6341 (0x18c5)
Current Motor 1 = 87 (0x57), Motor 2 = 75 (0x4b), Voltage = 6341 (0x18c5)
Current Motor 1 = 90 (0x5a), Motor 2 = 72 (0x48), Voltage = 6268 (0x187c)
Current Motor 1 = 85 (0x55), Motor 2 = 72 (0x48), Voltage = 6341 (0x18c5)
Current Motor 1 = 73 (0x49), Motor 2 = 70 (0x46), Voltage = 6350 (0x18ce)
Current Motor 1 = 68 (0x44), Motor 2 = 76 (0x4c), Voltage = 6268 (0x187c)
Current Motor 1 = 85 (0x55), Motor 2 = 70 (0x46), Voltage = 6341 (0x18c5)
Current Motor 1 = 83 (0x53), Motor 2 = 70 (0x46), Voltage = 6322 (0x18b2)
Current Motor 1 = 76 (0x4c), Motor 2 = 78 (0x4e), Voltage = 6259 (0x1873)
Current Motor 1 = 85 (0x55), Motor 2 = 67 (0x43), Voltage = 6295 (0x1897)
Current Motor 1 = 69 (0x45), Motor 2 = 71 (0x47), Voltage = 6322 (0x18b2)
Current Motor 1 = 70 (0x46), Motor 2 = 69 (0x45), Voltage = 6240 (0x1860)
Current Motor 1 = 79 (0x4f), Motor 2 = 67 (0x43), Voltage = 6304 (0x18a0)
Current Motor 1 = 78 (0x4e), Motor 2 = 70 (0x46), Voltage = 6350 (0x18ce)
```

This data in a boxplot diagram displays information about the the power consumption of the robot.

![box plot current](robot/img/box-plot-current)

__Statistics:__
```
Population size: 36
Median: 72
Minimum: 64
Maximum: 87
First quartile: 69.25
Third quartile: 78
Interquartile Range: 8.75
Outlier: 87
```

The motor is powered with four batteries (each 1900mAH), the entire energy of the batteries are 7600mAH. The calculation
with the maximum current of bth motors (172mA) results in a maximum working time of about 40h.

![calculation of working time](robot/img/working-time.gif)

## Software

The software is a small pythons script that uses [ws4py](https://ws4py.readthedocs.org/en/latest/) as websocket library
and [DMCC](https://github.com/Exadler/DMCC_Library) to interact with the MotorControllerCape.

### WS4PY

Excerpt from the [documentation of ws4py](https://ws4py.readthedocs.org/en/latest/sources/basics/):

ws4py provides a high-level, yet simple, interface to provide your application with WebSocket support. It is simple as:

```python
from ws4py.websocket import WebSocket
```

The `WebSocket <ws4py.websocket.WebSocket>` class should be sub-classed by your application. To the very least we
suggest you override the `received_message(message) <ws4py.websocket.WebSocket.received_message>` method so
that you can process incoming messages.

For instance a straightforward echo application would look like this:

```python
class EchoWebSocket(WebSocket):
    def received_message(self, message):
        self.send(message.data, message.is_binary)
```

Other useful methods to implement are:

   * `opened() <ws4py.websocket.WebSocket.opened>` which is called whenever the WebSocket handshake is done.
   * `closed(code, reason=None) <ws4py.websocket.WebSocket.closed>` which is called whenever the WebSocket connection
     is terminated.

You may want to know if the connection is currently usable or `terminated <ws4py.websocket.WebSocket.terminated>`.

At that stage, the subclass is still not connected to any data source. The way ws4py is designed, you don't
necessarily a connected socket, in fact, you don't even need a socket at all.


```python
>>> from ws4py.messaging import TextMessage
>>> def data_source():
>>>     yield TextMessage(u'hello world')

>>> from mock import MagicMock
>>> source = MagicMock(side_effect=data_source)
>>> ws = EchoWebSocket(sock=source)
>>> ws.send(u'hello there')
```

### DMCC

The DMCC library enables python to interact with the motor controller cape. The cape generates a PWM proportional to
a value between -10000 and 10000 which can be configured over a Python interface. The Cape can be stacked 4 times.

For the Swank-Rats robot we use one cape to control two motors, one for left and one for right.

It provides an easy to use python interface.

```python
import DMCC

# turns on motor 1 on board 0 with 50% power
DMCC.setMotor(0, 1, 5000)

# reverse direction on motor two with 70% power
DMCC.setMotor(0, 2, -7000)

# turn off the motor
DMCC.setMotor(0,1,0)
```

### State machine

The state machine calculates the current speed of the motor left and right. Therefore the websocket library forward
the commands press and release to the current state, which is initialized with the state Stop.

![robot state machine](robot/img/state_machine.jpg)

__Example:__

* The current state is `Stop`
* Press `left` the state `Stop` returns new state `L`
* Press `straight` the state `L` returns new state `FL`
* Release `left` the state `FL` return new state `F`

```python
class State:
    def __init__(self):
        pass

    def press(self, key):
        return Stop()

    def release(self, key):
        return Stop()

    def getLeft(self):
        return 0

    def getRight(self):
        return 0


class Stop(State):
    def press(self, key):
        if key == "left":
            return L()
        if key == "right":
            return R()
        if key == "straight":
            return F()
        if key == "backwards":
            return B()
        return Stop()

    def release(self, key):
        return Stop()


class F(State):
    def press(self, key):
        if key == "left":
            return FL()
        if key == "right":
            return FR()
        return Stop()

    def release(self, key):
        return Stop()

    def getLeft(self):
        return 100

    def getRight(self):
        return 100


class MessageParser:
    """Parses JSON messages an performs the according SwankRatsRobot action"""

    def __init__(self):
        self.robot = Robot()
        self.currentState = StateClasses.Stop()

    def execute(self, key, pressed):
        if pressed:
            self.currentState = self.currentState.press(key)
        else:
            self.currentState = self.currentState.release(key)

        self.robot.set(self.currentState.getLeft(), self.currentState.getRight())
```

## Supervisor

Supervisor is a client/server system that allows its users to control a number of processes on UNIX-like operating
systems. It was inspired by the following:

* Convenience
* Accuracy
* Delegation
* Process Groups

Swank-Rats use it to automatic start and restart the robot script if it crashes. For this it is configured to try
restart 100 times after crash or restart the system.

This file is a example config file which is used on the robots.

```ini
[program:swank-rats]
command=python /root/roboter-software/SwankRatsRoboterSoftware/Main.py
directory=/root/roboter-software/SwankRatsRoboterSoftware
autostart=true
autorestart=true
startretries=100
stderr_logfile=/var/log/swank-rats.err.log
stdout_logfile=/var/log/swank-rats.out.log
```

To enable web we added this to the config file of supervisor (more informations under the install section).

```ini
[inet_http_server]
port = 9001
username = admin
password = admin
```

After a restart the web ui can be located for example at `http://192.168.43.242:9001/`:

![Supervisor web ui](robot/img/supervisor)
