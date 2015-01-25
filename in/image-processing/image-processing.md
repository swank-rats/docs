
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
* Providing video stream for clients
* Collision detection
	- Robot/wall collision
	- Shot/robot collision
	- Robot/robot collision
	- Shot/wall collision
* Position detection of walls/robots
* Communication with NodeJS server
* Simulation of shoots in video stream

### Communication with NodeJS server
It is necessary that the NodeJS server and the image-processing can talk with each other. The communication is needed, because the NodeJS server has not enough knowledge to make all the game logic decision by its own. 

The following messages can be sent:

* Messages by image-processing server to the NodeJS server
	- If a collision was detected (see above which cases exist)
	- If a shot was made to notify if a robot was hit or not
* Messages by NodeJS server to image-processing server
	- If a shot was make by a player
	- If game has stopped
	- If game has started
	- If game has paused (e.g. connection problems)
	- Info about which player has which robot

### Video quality and resolution
For our project we use the webcam LifeCam HD-3000 from the manufacturer Microsoft. We decided to use 720p resolution for the streaming. This allows us to provide the clients a gaming environment in a today acceptable resolution without too much traffic through the transmission. 
Therefore the system need following requirements

* Intel Dual Core 3.0 GHz or higher
* 2 GB of RAM 
* 1.5 GB 
* USB 2.0 required

The maximal resolution for motion video is 1280 X 720 pixel for still image 1280 X 800. The webcam has a maximal image rate up to 30 frames per second and a 68.5 degree diagonal field of view.
The other image features of the webcam are

* Digital pan, digital tilt, vertical tilt, swivel pan, and 4x digital zoom
* Fixed focus from 0.3m to 1.5m
* True Color - Automatic image adjustment with manual override
* 16:9 widescreen
*24-bit color depth

### Latency
TODO what we want
TODO Messung der gesamten Schussüberlagerung und Senden an den Client

## Architecture
TODO Architecture diagram

### Simulation Shot
The below shown figure illustrates how a the shot simulation process in our application works.
![sequence diagram shot](image-processing/img/Shot)

## Object detection

### Lessons learned
At the beginning of our object detection task we tried different detection solutions out.

* RGB detection
* HSV detection
* Contour detection with marker
* Moving detection

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

#### Contour detection with marker
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

#### Moving detection
We also tried to detect a object via his motion. This method has the advantage that the tracking distance is much higher as by the marker method.
The disadvantage is that the robot must start in a certain position (cheese spin forward) to enable it using vector calculations to determine the new position of the cheese spin after a motion step.
Furthermore, it is not possible to use this technology to turn the robot in the state, because that would have no effect on the motion detection.
Because of the fact that the detection of the front of the robot is easier with the marker detection and also the detection of the front after a robot turn in the state we decided to not use the moving detection.


#### Conclusion Lessons learned
After our tests we decided to use contour detect for our object detect. The reason for this is that the detect
via contours works faster, more stable and produces less errors during the detect produces than the RGB and HSV detection.
We also decided us against the moving detection because of the fact that the detection of the front of the robot is easier with the marker detection and also the detection of the front after a robot turn in the state.



### Object detection realization
#### Robot detection
We decided to detect the Robots via a contour detection method

In order to bring more security in the contour detection, we have decided to use nested contours instead of simple contours.
This enables us to detect the object more error-free and more stable then with simple contours.

We decided to used the following geometric forms:
* Rectangle with isosceles triangle in it
* Pentagon with isosceles triangle in it

But at the end of our project we found out that the pentagon is not the best opposite form for the rectangle. Instead of the pentagon we now use a circle wit a isosceles triangle in it.

##### Detection processing
In our detection process for a robot we first convert the original image of the video stream in to another color space via the following method
```C++
cvtColor(srcdetect2, src_graydetect2, COLOR_BGR2GRAY);
```
We convert the original image BGR space into a GRAY space and save this in a template image.
After this converting process use the following blur function to smooth the image.
```C++
blur(src_graydetect2, src_graydetect2, Size(3, 3));
```
The main objective of smoothing is to reduce noise. Such noise reduction is a typical image pre-processing method which will improve the final result.
Smoothing is done by sliding a window (kernel or filter) across the whole image and calculating each pixel a value based on the value of the kernel and the value of overlapping pixels of original image. This process is mathematically called as convolving an image with some kernel. 
We used the homogeneous smoothing method. This is the most simplest method of smoothing an image. It takes simply the average of the neighbourhood of a pixel and assign that value to itself.
You have to choose right size of the kernel. If it is too large, small features of the image may be disappeared and image will look blurred. If it is too small, you cannot eliminate noises of the image.
We decided to use a 3x3 Kernel because we thus achieve the best results. 

The next step is that wie make a Canny Edge detection to extract the edges
```C++
Canny(src_graydetect2, canny_output, threshdetect2, threshdetect2 * 2, 3);
```
Canny algorithm aims to satisfy three main criteria:
* Low error rate: Meaning a good detection of only existent edges.
* Good localization: The distance between edge pixels detected and real edge pixels have to be minimized.
* Minimal response: Only one detector response per edge.

The values of the thresholds must be set before the games started at the moment the thresholds are set between 30 and 60.
The selected threshold value depends on the distance to the object and the environment of the detection area.

After the canny detection we run a threshold function over the image. Therefore we use a binary threshold method
```C++
threshold(canny_output, canny_output, 128, 255, CV_THRESH_BINARY);
```

For the circle marker detection we must perform following method before we search after the contours because with the standard findContours method you can not find circles 
```C++
HoughCircles(src_graydetect2, circles, CV_HOUGH_GRADIENT, 1, src_graydetect2.rows / 8, 60, 30, 0, 0);
```

After all this preparation steps we call the find contours method  which returns all founded contours.
```C++
findContours(canny_output, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE);
```
contours – Detected contours. Each contour is stored as a vector of points.
hierarchy – Optional output vector, containing information about the image topology. 
It has as many elements as the number of contours. For each i-th contour contours[i] , 
the elements hierarchy[i][0] , hiearchy[i][1] , hiearchy[i][2] , and hiearchy[i][3] 
are set to 0-based indices in contours of the next and previous contours at the same hierarchical level,
the first child contour and the parent contour, respectively. If for the contour i there are no next, 
previous, parent, or nested contours, the corresponding elements of hierarchy[i] will be negative.
CV_RETR_TREE - retrieves all of the contours and reconstructs a full hierarchy of nested contours.
CV_CHAIN_APPROX_SIMPLE - compresses horizontal, vertical, and diagonal segments and leaves only their end points. For example, an up-right rectangular contour is encoded with 4 points.

After this step we iterate over each founded contour and try to find our rectangle and triangle forms.
In each iteration step we first call the approxPolyDP method. Approximates a polygonal curve(s) with the specified precision.
```C++
approxPolyDP(cv::Mat(contours[i]), approx, cv::arcLength(cv::Mat(contours[i]), true)*0.1, true);
````
The functions approxPolyDP approximate a curve or a polygon with another curve/polygon with less vertices so that the distance between them is less or equal to the specified precision. It uses the Douglas-Peucker algorithm

Then we skip small or non-convex objects and only extract the rectangle and triangles (Code below shows the rectangle marker detection)
```C++
if (std::fabs(cv::contourArea(contours[i])) < 100 || !cv::isContourConvex(approx))
	continue;

// Rectangles

if (approx.size() == 4)
{
	rectangles.push_back(contours[i]);
	rectanglesContourPositions.push_back(i);
}

if (approx.size() == 3)
{
	triangles.push_back(approx);
	trianglePositions.push_back(i);
}
```




After that we check via the pointPolygonTest method of opencv if on of our founded triangle is in one of our founded rectangles or circles.
This method returns us the position of the allowed rectangle and circles and triangles.
With this information we can calculate the front and the shooting direction of the cheese spin.
Below you can se the method which calculate this.
```C++
Point p1 = tri[0];
Point p2 = tri[1];
Point p3 = tri[2];

Point lP1P2 = p1 - p2;
Point lP2P3 = p2 - p3;
Point lP3P1 = p3 - p1;

double l1 = sqrt((lP1P2.x*lP1P2.x) + (lP1P2.y*lP1P2.y));
double l2 = sqrt((lP2P3.x*lP2P3.x) + (lP2P3.y*lP2P3.y));
double l3 = sqrt((lP3P1.x*lP3P1.x) + (lP3P1.y*lP3P1.y));

double shortest = l1;
Point toReturn = p3;
Point dir = Point(lP1P2.x / 2, lP1P2.y / 2) + p2;

if (l2 < shortest)
{
	shortest = l2;
	toReturn = p1;
	dir = Point(lP2P3.x / 2, lP2P3.y / 2) + p3;
}
if (l3 < shortest)
{
	shortest = l3;
	toReturn = p2;
	dir = Point(lP3P1.x / 2, lP3P1.y / 2) + p1;
}

Point direction = toReturn - dir;
vector<Point> points;
points.push_back(direction);
points.push_back(dir);
return points;
```

After we finished the robot detection and return a Robot object with the informations to the caller method
```C++
if (pointsTriRect.size() == 2)
	return Robot(pointsTriRect[1], pointsTriRect[0], contoursRect);
```

#### Shoot route calculation
To detect the shoot route we make following steps.
First we detect the shooting robot via the robot detection process explained above;
```C++
Robot robotShootPlayer = DetectRobot(player, frame);
```

Fist we calculate the normalized shooting direction vector. The shooting direction was calculated in the robot detection process.
We added a multiplier to the normalized vector to reduced the time for the calculation.
```C++
double length = sqrt(pow(robotShootPlayer.shotDirection.x, 2) + pow(robotShootPlayer.shotDirection.y, 2));
int multiplier = 5;
Point normDirection = Point(robotShootPlayer.shotDirection.x / length * multiplier, robotShootPlayer.shotDirection.y / length * multiplier);
```

After that we calculation the shoot route started from the cheese spin of the shooting robot to the end of the play area.
For that we start a iteration and in each of this iteration we add the normalized shooting direction vector of the shooting player to the shooting start point.
We make procedure as long as we run out of the playing area.
```C++
while (!found)
	{
		if (!rect.contains(currentPoint))
		{
			endPoint = currentPoint - normDirection;
			found = true;
		}

		currentPoint += normDirection;
	}
```

At least we return the Shot route to the caller method
```C++
return Shot(player, Point2i(robotShootPlayer.shotStartingPoint.x, robotShootPlayer.shotStartingPoint.y), Point2i(endPoint.x, endPoint.y));
```

#### Hit detection
To detect a hit we make following steps.
First we detect the hit robot via the robot detection process explained above;
```C++
Robot robotHitPlayer = DetectRobot(shot.hitPlayer, frame);
```

After this we fetch the actual position of the thrown cheese int the shot route.
```C++
Point2i tmp = shot.GetCurrentShotPoint();
```
With this point we look if the point is in the contours of the robot via the pointPolygonTest method(the marke have the same size as the robots).
The result will be returned to the caller method.
```C++
if (pointPolygonTest(Mat(robotHitPlayer.robotForm), currentShotingPoint, true) > 0)
	return true;
else
	return false;
```

### Performance measurement object recognition
During our project we had the problem that our webcam streaming was very slow. After hours of searching we found out that one reason for the problem was that our object detection recognition was to slow.
So we started a performance measurement were we measure each method call. By this time measurement, we found out that the most time of our object recognition is needed from the opencv method like cvtColor, blur, findContours,etc.
Below you can see the results of this measurement.

![image processing time](image-processing/img/imageProcessingTime.jpg)

According to this knowledge we have tried to improve image processing. We enlarged the size of the objects after that we search. This brought us an improvement of about 20ms.
However, our hands are tied because we  unfortunately cases improve the opencv methods.





## Websocket communication

TODO

### Handling of connection loss
If the connection to the NodeJS server gets lost we try to reconnect for one second. In this time all outgoing messages will be buffered and if a reconnect was successful, they will be sent. Otherwise they will be lost and not sent. 


## Video streaming to HTML client
We decided to use [Motion JPEG (MJPEG)](http://en.wikipedia.org/wiki/Motion_JPEG) since it is very easy to implement, has only less restrictions and can be easily provided over HTTP.

### How does it work
The protocol is quiet easy to understand. The browser of a client sends a normal HTTP GET request to our server. We need to answer the request with HTTP 200 OK and set the content type to "multipart/x-mixed-replace; boundary=--VIDEOSTREAM". This signals the client to expect several parts delimited by the boundary name "--VIDEOSTREAM". The TCP connection is not closed until the server or the client closes it.

The following image shows the communication between the client and the server. The TCP ACKs were not mentioned. If the packet size is bigger than 1500 bytes, it will be automatically split up into several parts.

![MJPEG communication](image-processing/img/mjpeg_successful_request_response)

Further information about MJPEG can be found here:

* [Wikipedia Motion JPEG](http://en.wikipedia.org/wiki/Motion_JPEG)
* [MJPEG protocol definition](http://www.damonkohler.com/2010/10/mjpeg-streaming-protocol.html)

### Advantages and Disadvantages
MJPEG has the big advantages that it is easy to implement, no further libraries were needed and on the client side most of the modern browser like Google Chrome, Mozilla Firefox, Safari or Opera support MJPEG natively. Only Microsoft Internet Explorer does not support it.

The disadvantages were the inefficiency compared to more modern formats like H.264/MPEG-4 AVC as you have to always send the whole image. There is no interframe compression like in other, more modern standards. In our case we were also faced to some performance loss caused by the TCP connection, which we have to use since we talk to a browser.

### Handling of connection loss
Handling of connection loss is not that easy since MJPEG functionality is embedded into the clients browser and we have no control about it. 

TODO

### Handling of no available video stream
If no video stream is available, e.g. if no webcam is connected to the server, we cannot provide a video stream. In such a case all incoming video stream requests will be answered with HTTP/1.1 500 OK. The HTTP status code 500 means an internal server error occurred. Afterwards the connection is closed. 

### High delays
At the beginning we were faced with high delay rates of over 70 ms between each frame on the client. It felt like it was even more.

We figured out that there were several reasons for this. Two main problems were directly located in our implementation. We had some unneeded thread synchronization code and we also cloned each frame, which is not necessary since the used data structure ([OpenCV Mat](http://docs.opencv.org/modules/core/doc/basic_structures.html#mat)) provides reference counting. So a copy of a Mat object will not result in copying the whole image. Both instances will share the matrix, which represents the image. 

Next we figured out that we send about 80 - 90 kb per frame. We solved the problem by decreasing the quality of the image we send. OpenCV provides the possibility to change the quality very easily during converting a Mat object into a vector of bytes. So we could decrease the size per frame to about 10 kb by setting the quality to 30 %. 

TODO add image that compares original stream with stream received by client

With this few changes we could decrease the delay to about 20 ms, which is acceptable. 

One big disadvantage, which costs a lot of performance, is the TCP connection overhead. Sadly it is not possible to provide an MJPEG stream via UDP to a browser. 

## Cheese-throw simulation
The simulation of throwing a cheese is done by overlay the webcam stream with the images needed for the simulation. One Cheese-throw simulation consists of three parts:

1. Throw-animation: a small explosion in front of the robot shows the start of a throw
2. Cheese-throwing-animation: the explosion is followed by a cheese, which is animated to simulate a flying cheese beginning at the robot and ending at the calculated end position
3. Hit-animation: when the flying cheese reaches the end position a explosion is simulated

The following image illustrated all three states.

![Cheese-throw simulation states](image-processing/img/Shot_animation)

A simulation is started if the NodeJS server tells the image processing server that a cheese was thrown by a player. We can then determine the start and end point of a cheese-throw simulation, since we know the position and the viewing direction of the throwing player and by the fact that we are only simulating straightly throws.. The simulation is immediately started with the next occurring webcam frame and therefore also immediately visible for the clients. The decision, if a player or a wall was hit by the cheese is done when the simulation reached the end point. So we can ensure that the other player gets the chance to avoid a collision with the cheese. 

The calculations for a simulation is not that complicated since the start and end point can be interpreted as a right-angled triangle, as the following image illustrates.

![Cheese-throw simulation right-angled trigangle](image-processing/img/Shot_rect)

The simulation takes place along c (hypotenuse). We just have to calculate the length of a and b, shown in the image above by doing the following calculation:

* a = endPointX - startPointX
* b = endPointY - startPointY

By doing it this way we do not have to consider the direction in detail since the following cases were covered:

* start point x < end point x: next point x > start point x; a > 0
* start point y < end point y: next point y > start point y; b > 0

* start point x > end point x: next point x < start point x, a < 0
* start point y > end point y: next point y < start point y, b < 0

* start point x = end point x: next point x = start point x; a = 0
* start point y = end point y: next point y = start point y; b = 0

This makes sure that all throw directions were possible without any additional magic in the code. The following image illustrates all directions.

![Cheese-throw directions](image-processing/img/Shot_area)

During the simulation the next point, where we show a cheese image, is calculated the following:

* next point x = start point x + a * percentage
* next point y = start point y + b * percentage

Since we an image in the background we have to round the results to integers, because we cannot consider e.g. half pixels.

As you can see we always add a specific percentage of the length of a to the start point x value and of b to the start point y value. The initial percentage is 3% and is increased by +3% after each simulation step. We use 3% since our tests figured out that 3% offers us the best balance between throwing speed (the image does not move too fast and not too slow) and the gaps between each cheese image. 
