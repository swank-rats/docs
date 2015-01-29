---
title:  'Swank-Rats documentation'
author:
- name: Thomas Gaida
  email: thomas.gaida@students.fhv.at
- name: Stefan Lässer
  email: stefan.laesser@students.fhv.at
- name: Johannes Schwendinger
  email: johannes.schwendinger@students.fhv.at
- name: Johannes Wachter
  email: johannes.wachter@students.fhv.at
- name: Michael Zangerle
  email: michael.zangerle@students.fhv.at
abstract: '{% include 'abstract.md' %}'
---

# Introduction

Swank-Rats is a mulitplayer, realtime, augmentmented reality, browser based, distributed and platform independent game. Which combines modern technologies and communication systems.

It was developed by a team of 5 people in the master course "S1: Coupling and Integration of Heterogeneous Systems" at [University of Applied Sciences Vorarlberg](http://www.fhv.at) in Dornbirn, Austria.

![University of applied science](http://upload.wikimedia.org/wikipedia/de/thumb/6/62/Fachhochschule_Vorarlberg_logo.svg/200px-Fachhochschule_Vorarlberg_logo.svg.png)

The following movie shows the current development state which will be presented at the graduation date. The image processing has
a few problems which results in:

* Some shots are not shown except of the end explosion.
* Sometimes the robot is not recognized which causes in faulty shot simulations.
* The live stream laggs sometimes

![[Youtube presentation video](http://www.youtube.com/watch?v=4hFU2bnblVc)](http://img.youtube.com/vi/4hFU2bnblVc/0.jpg)

## Game Idea

Swank-Rats is a rat fighter game. Two rats are trying to shoot each other with cheese. 
The rats are represented by robots which are controlled by two players. A camera is mounted above the game world, which offers the possibility to detect the rats position and to provide a live stream to the clients. It is also possible to detect obstacles like straight walls (e.g. wood slates). The walls serve as a limitation for the cheese-bullets.

The clients can see the robots via a live stream of the world displayed in a HTML UI in their browser. With buttons and keyboard shortcuts the player can control the real robot. 
 
If a robot is hit one or more times the game is over.

## Architecture

![Architecture of Swank-Rats](intro/img/architecture)

### Hardware

* 2 x rat robot with WLAN dongles to communicate with the server
* 1 x Webcam for displaying the world and image processing like robot position detection,...
* 1 x Server (notebook or personal computer for image processing and game logic)
* 2 x Clients (notebooks or personal computer with modern browsers)

### Server-Software

* Server Application (C++)
	- Image processing
	- Position detection
	- Overlay webcam stream with cheese-bullets
	- Offer webcam live stream to client
* Node.js Server
	- Robot control
	- Server UI (HTML)
	- User management

### Client

* Browser application
	- HTML5
	- Presentation of game stream
	- JavaScript with WebSockets
	- Buttons to control robot
	- Login
	- ...

## Communication

For the communication we use WebSockets. This TCP-based protocol provides bidirectional connections between all stations
of our infrastructure and is well supported by our used programming languages.

### Used Libraries

* Phyton uses the [ws4py](https://ws4py.readthedocs.org/en/latest) (WebSocket for Phyton) library
* Node.js uses the minimalistic implementation of WebSocket protocol [ws](https://github.com/einaros/ws) (websocket)
* C++ uses [POCO](http://pocoproject.org/documentation/index.html) which provides the WebSocket implementation 
* JavaScript in browser uses the nativ WebSocket API ([Tutorial](http://www.html5rocks.com/de/tutorials/websockets/basics/)) of the browser

### Protocol

For communication between the stations we use asyncronous JSON messages with a specific structure this structure is
implemented for Node.js in a open source module [WebSocket-Wrapper](https://github.com/swank-rats/websocket-wrapper). The implementation
of this module is part of this project.
