# Image-Processing

## Components
For the implementation of our image processing functionality we decided to use C++ in connection with the OpenCV 2.4.9 (http://opencv.org/) library. It will help us to get the video stream of a web cam, to detect the position of the robots and to detect collisions (e.g. collision between robot and wall, but also collisions between a shot and a wall/robot). For compiling our source code we use the MinGW GCC C++ 4.8.1-4 compiler.

## Why OpenCV and C++
We did some research and searched for possible free image processing libraries. We decided to use OpenCV, because it offers the biggest amount of functionality compared to the other libraries, which were available for free.

First we thought about using Java together with the ported OpenCV version, but then we were a little bit afraid about possible performance issues, instability and the fact, that you have to use native method calls in your Java code to get access to the OpenCV functionality since it is written for C/C++. 

Another possibility would have been C#.NET together with EmguCV (http://www.emgu.com/wiki/index.php/Main_Page). But EmguCV is also just a wrapper to the OpenCV library. 

So we decided to use OpenCV in connection with C++. It is a little bit risky because we do not have much experience in using C++ and it is the first time we use it in a project. So we are looking forward to learn a lot of new things.