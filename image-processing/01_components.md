# Image-Processing

## Components
For the implementation of our image processing functionality we decided to use C++ in connection with OpenCV 2.4.9 (http://opencv.org/). It will help us to get the video stream of a web cam, to detect the position of the robots and to detect collisions (e.g. collision between robot and wall, but also collisions between a shot and a wall or robot).

For the communication between the NodeJS server and the image-processing server we decided to use WebSockets. To fulfil this purpose we use the library XXXXX (TODO!).

For compiling our source code we use Microsoft Visual C++ Compiler 18.00.21005.1 for x86 platform. Therefore we also use Visual Studio 2013 as our IDE. During the project we will implement against the Win32 API (e.g. for threading and so on).

## Why WebSockets
TODO

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
The error log of the IDE did not mention anything helpful about this error. We got the same error with the previous Boost libary (1.55). After some research about this error message we finally gave up at this point and decided to changed to VS 2013, VC++ and implement against the Win32 API.
