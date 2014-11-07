## Requirements

### Needed functionality
- Providing video stream for clients
- Collision detection
	- Robot/wall collision
	- Shot/robot collision
	- Robot/robot collision
	- Shot/wall collision
- Position detection of walls/robots
- Communication with NodeJS server
- Simulation of shoots in video stream

### Communication with NodeJS server
It is necessary that the NodeJS server and the image-processing can talk with each other. The communication is needed, because the NodeJS server has not enough knowledge to make all the game logic decision by its own. 

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
For our project we use the webcam LifeCam HD-3000 from the manufacturer Microsoft. We decided to use 720p resolution for the streaming. This allows us to provide the clients a gaming environment in a today acceptable resolution without too much traffic through the transmission. 
Therefore the system need following requirements
- Intel Dual Core 3.0 GHz or higher
- 2 GB of RAM 
- 1.5 GB 
- USB 2.0 required

The maximal resolution for motion video is 1280 X 720 pixel for still image 1280 X 800. The webcam has a maximal image rate up to 30 frames per second and a 68.5 degree diagonal field of view.
The other image features of the webcam are
 Digital pan, digital tilt, vertical tilt, swivel pan, and 4x digital zoom
- Fixed focus from 0.3m to 1.5m
- True Color - Automatic image adjustment with manual override
- 16:9 widescreen
- 24-bit color depth

### Latency
TODO what we want

### Connection loss 
TODO what should happen
