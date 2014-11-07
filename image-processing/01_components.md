# Image-Processing

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

![Eclipse errors when building project](images/eclipse_boost_errors.png)

We adapted the fix, which is mentioned in the bug report, to our local boost source files and recompiled the library. The result was that Eclipse didn't run the application anymore. Instead it displayed the message "Launch failed. Binary not found.".

![Eclipse errors when building project](images/eclipse_boost_error2.png)

The error log of the IDE did not mention anything helpful about this error. We got the same error with the previous Boost libary (1.55). After some research about this error message we finally gave up at this point and decided to changed to VS 2013, VC++ and compiled Boost with the VC++ compiler. 

## Why using Poco instead of Boost
First we wanted to use [Boost](http://www.boost.org/) for the threading, networking and so on. Boost was also reason why we changed from Eclipse to Visual Studio. But finally, when we were faced with the communication of the image processing application to the NodeJS server, we investigated a lot of time to get WebSockets running with Boost and we failed. 

### Problems with WebSocket libraries
We tried to use [Simple-WebSocket-Server](https://github.com/eidheim/Simple-WebSocket-Server). One of the big advantages of this library would have been that it uses Boost.Asio, but we got the following compiler error:

	error C2338: invalid template argument for uniform_int_distribution	g:\visual studio 2013\vc\include\random	line 2767
	
We could not figure out where the source of this problem was exactly located. So we tried the next library.

Then we tried to use [Websocketpp](https://github.com/zaphoyd/websocketpp), which also uses Boost.Asio. Here we were faced to the following compiler error:

	error C2064: term does not evaluate to a function taking 2 arguments	c:\_libs\boost\1.56.0\boost\function\function_template.hpp	153
	
We had contact with the developer of this library. First he recommended to use Boost 1.55.0 instead of 1.56.0, but the problem still occurred. Finally we could figure out that the source of the problem was in the file "websocketpp\common\functional.hpp" where some defines were wrong, which caused the error in VC 2013. The developer fixed the problem 2 weeks after we have decided to use Poco.

Finally we found [Poco 1.4.7](http://pocoproject.org/), which is a library like BOOST. The big difference is that Poco already contains an API for creating a WebSocket server/client and also a HTTP server/client can be easily implemented. Poco was very easy to compile and get things running with VS2013. So we changed (again) the library from Boost to Poco.
