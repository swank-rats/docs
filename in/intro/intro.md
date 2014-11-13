---
title:  'Swank-Rats documentation'
lang: 'de'
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

TODO fancy description of project

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

![Architecture of Swank-Rats](intro/img/architecture)

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

### Protocol

For communication between the stations we use asyncronous json-messages with a specific structure this structure is
implemented for Node.JS in a Open Source module [Websocket-Wrapper](https://github.com/swank-rats/websocket-wrapper). The implementation
of this module is part of this project.
