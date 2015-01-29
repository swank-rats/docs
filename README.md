# Swank-Rats

Swank-Rats is a mulitplayer, realtime, augmentmented reality, browser based, distributed, platform independent and
awsesome game. Which combines modern technologies and communication systems.

It was developed by a team of 5 people in the course "S1 - Kopplung und Integration von heterogenen Systemen" at the
university of applied science in Dornbirn.

![University of applied science](http://upload.wikimedia.org/wikipedia/de/thumb/6/62/Fachhochschule_Vorarlberg_logo.svg/200px-Fachhochschule_Vorarlberg_logo.svg.png)

This movie shows the current development state which will be presented at the graduation date. The image processing has
a few problems which results in:

* Some shots are not shown except of the end explosion.
* Sometimes the robot is not recognized and the shot flying over it.

![[Youtube presentation video](http://www.youtube.com/watch?v=4hFU2bnblVc)](http://img.youtube.com/vi/4hFU2bnblVc/0.jpg)

## Game Idea

Swank Rat is a rat fighter game. Two rats are trying to shoot each other with cheese. 
The rats are represented by robots which are controlled by two players. With a Camera
over the Game-World can the software "see" where the rats are. In addition, the obstacles
are detected over this camera. This obstacles are straight walls (e.g. wood slates with
a red with a red mark). The Rats are able to throw pieces of cheese after the opponent.
The walls serve as a limitation for the cheese-bullets.

To control the robots the live video of the world (overlaid with video of the cheese-bullets)
will be displayed in a HTML UI in the browser. With buttons (and keyboard shortcuts) can
the player control the real robot.
 
If a robot is hit (one or more) the game is over.

## Architecture

![Architecture of Swank-Rats](https://github.com/swank-rats/docs/blob/master/in/intro/img/architecture.png)

### Hardware

* 2 x "Rat-Robot" with WLAN Dongles to communicate with the server
* 1 x Webcamera (for the detection of position and world)
* 1 x Server (Notebook or PC for image processing and game logic)
* 2 x Clients (Notebooks with modern Browsers)

### Server-Software

* Server Application (Java)
	- Image processing
	- Position detection
	- Overlay webcam video with cheese-bullets
	- Stream video for client
* NodeJS Server
	- Robot control
	- Server UI (HTML)
	- User management

### Client

* Browser Application
	- HTML5
	- Presentation of game stream
	- Javascript with Websockets
	- Buttons to control robot
	- Login
	- ...

## Communication

For the communication we use Websockets. This TCP-based protocol provides bidirectional connections between all stations
of our infrastructure and is well supported by all languages.

### Used Libraries

* Phyton uses the [ws4py](https://ws4py.readthedocs.org/en/latest) (Websocket for Phyton) library
* Node-JS uses the minimalistic implementation of Websocket Protocol [ws](https://github.com/einaros/ws) (websocket)
* C++ uses [POCO](http://pocoproject.org/documentation/index.html) which provides the Websocket implementation 
* JavaScript in Browser uses the nativ Websocket API ([Tutorial](http://www.html5rocks.com/de/tutorials/websockets/basics/)) of the browser
