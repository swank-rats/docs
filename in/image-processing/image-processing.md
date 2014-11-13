
# Image-Processing

TODO fancy description for image-processing

## Components
For the implementation of our image processing functionality we decided to use C++ in connection with OpenCV 2.4.9 (http://opencv.org/). It will help us to get the video stream of a webcam, to detect the position of the robots and to detect collisions (e.g. collision between robot and wall, but also collisions between a shot and a wall or robot).

For networking, including HTTP and WebSockets, threading and logging we use the functionality provided by the [Poco C++ Libraries 1.4.7](http://pocoproject.org/).

For the communication between the NodeJS server and the image-processing server we decided to use WebSockets and JSON objects. To fulfil this purpose we can use the API of Poco.

For compiling our source code we use Microsoft Visual C++ Compiler 18.00.21005.1 for x86 platform. Therefore we also use Visual Studio 2013 as our IDE. 

## Why OpenCV and C++
We did some research and searched for possible free image processing libraries. We decided to use OpenCV, because it offers the biggest amount of functionality compared to the other libraries which were available for free like SimpleCV, OpenCV for Java, OpenCV for .NET (Emgu CV) or JAI. We do not want to take the risk to use a library which offers less functionality and finally we may be faced with the problem, that a functionality that we need is missing.

First we thought about using Java together with the ported OpenCV version, but then we were a little bit afraid about possible performance issues, instability and the fact, that you have to use native method calls in your Java code to get access to the OpenCV functionality since it is written for C/C++. Also offers the wrapper for OpenCV under java less functionality then the original OpenCV for C++.

Another possibility would have been to use C#.NET. There are several opportunities like [EmguCV](http://www.emgu.com/wiki/index.php/Main_Page), [Halcon](http://www.halcon.com) or [Aforge.Net](http://www.aforgenet.com). But since EmguCV is also just a wrapper for the OpenCV library, the Halocn library is not available for free and our researched figured out that it is more recommended to use OpenCV before using Aforge.NET, C#.NET was no option anymore.

So we decided to use OpenCV in connection with C++. It is a little bit risky because we do not have much experience in using C++ and it is the first time we use it in a project. So we are looking forward to learn a lot of new things.

## Why VC++ with VS 2013
First we wanted to implement our project with Eclipse CDT in connection with the [Boost library](http://www.boost.org/). The reason for us to use Boost was that we were especially interested in the threading and networking functionality, because we have a team member with a Mac and we wanted to offer him opportunity to develop with us. But the current version of the Boost library contains an [already reported bug](https://svn.boost.org/trac/boost/ticket/10296), which causes the build of Boost with MinGW to create corrupt files. This finally leads to an error in Eclipse, when you try to build the project.

![Eclipse errors when building project](image-processing/img/eclipse_boost_errors)

We adapted the fix, which is mentioned in the bug report, to our local boost source files and recompiled the library. The result was that Eclipse didn't run the application anymore. Instead it displayed the message "Launch failed. Binary not found.".

![Eclipse errors when building project](image-processing/img/eclipse_boost_error2)

The error log of the IDE did not mention anything helpful about this error. We got the same error with the previous Boost libary (1.55). After some research about this error message we finally gave up at this point and decided to changed to VS 2013, VC++ and compiled Boost with the VC++ compiler. 

## Why using Poco instead of Boost
First we wanted to use [Boost](http://www.boost.org/) for the threading, networking and so on. Boost was also reason why we changed from Eclipse to Visual Studio. But finally, when we were faced with the communication of the image processing application to the NodeJS server, we investigated a lot of time to get WebSockets running with Boost and we failed. 

### Problems with WebSocket libraries
We tried to use [Simple-WebSocket-Server](https://github.com/eidheim/Simple-WebSocket-Server). One of the big advantages of this library would have been that it uses Boost.Asio, but we got the following compiler error:

	error C2338: invalid template argument for uniform_int_distribution	g:\visual studio 2013\vc\include\random	line 2767
	
We could not figure out where the source of this problem was exactly located. So we tried the next library.

Then we tried to use [Websocketpp](https://github.com/zaphoyd/websocketpp), which also uses Boost.Asio. Here we were faced to the following compiler error:

	error C2064: term does not evaluate to a function taking 2 arguments	c:\_libs\boost\1.56.0\boost\function\function_template.hpp	153
	
We had contact with the developer of this library. First he recommended to use Boost 1.55.0 instead of 1.56.0, but the problem still occurred. Finally we could figure out that the source of the problem was in the file "websocketpp\\common\\functional.hpp" where some defines were wrong, which caused the error in VC 2013. The developer fixed the problem 2 weeks after we have decided to use Poco.

Finally we found [Poco 1.4.7](http://pocoproject.org/), which is a library like BOOST. The big difference is that Poco already contains an API for creating a WebSocket server/client and also a HTTP server/client can be easily implemented. Poco was very easy to compile and get things running with VS2013. So we changed (again) the library from Boost to Poco.

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

## Architecture
TODO Architecture diagram

## Object detection

### Lessons learned
At the beginning of our object detection task we tried different detection solutions out.
-RGB detection
-HSV detection
-contour detection with marker

#### RGB Color detection
First of all we tried to solve the object detection by using a color detection.
There we started with a simple RGB color adjustment. But this adjustment brought not the desired success.
When using RGB we had too much influence by the light of the environment and when the object distance to the camera was to far
we could not recognize the object any more. 

#### HSV Color detection
After the RGB detection we tried to detect the object via HSV colors. This worked alot better then the detection via RGB. But it also brought not the desired success.
Also here we had too much influence by the light of the environment and when the object distance to the camera was to far
we could not recognize the object any more. Compared to the RGB detection the distance was greater but for our solution to short.

HSV (hue-saturation-value) is the most common cylindrical-coordinate representations of points in an RGB color model.
It rearrange the geometry of RGB in an attempt to be more intuitive and perceptually relevant than the cartesian (cube) representation, 
by mapping the values into a cylinder loosely inspired by a traditional color wheel. The angle around the central vertical axis corresponds to "hue" and the distance from the axis corresponds to "saturation". 
Perceived luminance is a notoriously difficult aspect of color to represent in a digital format (see disadvantages section), and this has given rise to two systems attempting to solve this issue:
Both of these representations are used widely in computer graphics, but both are also criticized for not adequately separating color-making attributes, and for their lack of perceptual uniformity.
 
![HSV model](image-processing/img/hsv_models)

Below you can see the detection result of our HSV detection. First you see the original image and then our detection result which detect blue forms.

![HSV detection original image](image-processing/img/colored_squares)

![HSV detection after detect blue forms](image-processing/img/hsv_detection1)

#### contour detection with marker
We also tried to detect the object via its contours.
To realize this we went forth and first tried various geometry forms and tried to recognize them by there contours.
Below you can see the detection result. First you see the original image and then our detection result.

![Rectangle model](image-processing/img/colored_squares)

![Rectangle model after detection](image-processing/img/contour1)

In order to bring more security in the contour detection, we have decided to replace the simple contours by nested contours
This enables us to detect the object more error-free and more stable then with simple contours.
Below you can see the detection with nested contours. Only the rectangles with triangles in the rectangles boundaries are detected.

![Rectangle model nested](image-processing/img/originalImageNestedDetection)

![Rectangle model nested after detection](image-processing/img/detectionImageNestedDetection)

### Conclusion Lessons learned
After our tests we decided to use contour detect for our object detect. The reason for this is that the detect
via contours works faster, more stable and produces less errors during the detect produces than the RGB and HSV detection.

## Websocket communication
TODO

## Video streaming with HTML client
TODO

MJPEG

http://de.wikipedia.org/wiki/Motion_JPEG
http://en.wikipedia.org/wiki/Motion_JPEG#M-JPEG_over_HTTP
http://www.damonkohler.com/2010/10/mjpeg-streaming-protocol.html

First we had a latency of over 70 ms between each image frame.
-Reasons:
-image file size too big (up to 70 kb)
-unneeded threading synchronization in code
-unneeded cloning of the captured images in the code
-JPEG image, which was sent over network, quality was 100% (leads to bigger file sizes)
-TCP connection overhead (problem of MJPEG).

Solutions:
-removed unneed sync
-removed cloning
-decreased jpeg image quality to 30%
-therefore the file size shrink to about 10 kbs
Result:
latency is between 20-30 ms
