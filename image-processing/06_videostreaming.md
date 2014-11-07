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