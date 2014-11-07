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
![HSV model](images/hsv_models.png)


Below you can see the detection result of our HSV detection. First you see the original image and then our detection result which detect blue forms.
![HSV detection original image](images/colored_squares.png)
![HSV detection after detect blue forms](images/hsv_detection1.png)


#### contour detection with marker
We also tried to detect the object via its contours.
To realize this we went forth and first tried various geometry forms and tried to recognize them by there contours.
Below you can see the detection result. First you see the original image and then our detection result.
![Rectangle model](images/colored_squares.png)
![Rectangle model after detection](images/contour1.png)

In order to bring more security in the contour detection, we have decided to replace the simple contours by nested contours
This enables us to detect the object more error-free and more stable then with simple contours.
Below you can see the detection with nested contours. Only the rectangles with triangles in the rectangles boundaries are detected.
![Rectangle model nested](images/originalImageNestedDetection.png)
![Rectangle model nested after detection](images/detectionImageNestedDetection.png)

### Conclusion Lessons learned
After our tests we decided to use contour detect for our object detect. The reason for this is that the detect
via contours works faster, more stable and produces less errors during the detect produces than the RGB and HSV detection.



