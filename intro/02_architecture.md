## Architecture

TODO overview image

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
