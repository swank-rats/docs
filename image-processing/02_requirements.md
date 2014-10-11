## Requirements

### Needed functionality
- Providing video stream for clients
- Collision detection
	- Robot/wall collision
	- Shot/robot collision
	- Robot/robot collision
- Position detection of walls/robots
- Communication with NodeJS server
- Simulation of shoots in video stream

### Communication with NodeJS server
It is necessary that the NodeJS server and the image-processing can talk with eachother. The communication is needed, because the NodeJS server has not enough knowledge to make all the game logic decision by its own. 

The following messages can be sent:
- Messages by image-processing server to the NodeJS server
	- If a collision was detected (see above which cases exist)
	- If a shot was made to notify if a robot was hit or not
- Messages by NodeJS server to image-processing server
	- If a shot was make by a player
	- If game has stopped
	- If game has started
	- If game has paused (e.g. connection problems)
	- Info about which player has which robot

### Video quality and resolution
