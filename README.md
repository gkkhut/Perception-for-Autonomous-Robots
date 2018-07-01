# Perception-for-Autonomous-Robots
Lane and vehicle alignment detection using Hough Lines/Probabilistic Hough lines, RANSAC, Traffic Sign detection and recognition using HOG + SVM for detection and recognition, Visual odometry.

# Lane detection
In this project, the task was to detect lanes which is one of the basic task needed in any autonomous cars. One of the objective of this course was to make students capable of working on self-driving cars. This project was the first step towards that goal. Some pre-processing of the image and Hough transforms the task was completed. Usage of Hough transforms is prefered over any other methods since it requires lesser computational power. Taking the further and building up on this, the next step is to predict the curvature of the road. For this, the line fitted on the lanes are extrapolated and use the center of the frame to predict the curvature. Following figure shows the output of the algortihm.

# Visual Odometry
This project has is a crucial task for driverless cars. It is one of the cutting edge algorithms used currently in many robotics' projects. Visual odometry obtains the information of the location of the vehicle from the video stream obtained from the RGBD camera. Taking it one step ahead, in this project visual odometry is computed from monocular camera without any depth information obtained directly from the camera. The position of the camera is tracked across the frames by computing Essential matrices, obtaining rotation and translation matrices from it, and selecting correct Essential matrix by doing triangulation. The trajectory of the vehicle calculated for the given video is shown below.

# Color Segmentation - Buoy Detection
This is one of the projects which uses basic concepts of color segmentation combining it with Gaussian Mixture models to detect the underwater buoys. After much contemplating and experimenting with different colorspaces, in this project RGB colorspace is used for buoy detection. The training data was generated manually which was then provided to GMM which identifies the optimum combination of the color channels in the frame. A sample output is as shown below:

# Traffic Sign Recognition
Another important task in any autonomous car is to detect and recognize traffic signs on the road. There are two steps in this project:

To detect the traffic signs from the incoming video stream
Recognize the detected traffic signs.
For detection of traffic signs, simple color segmentation technique is used in HSV color space. To filter out false positives another restriction was implemented on the aspect ratio of the bounding box. Implementing this step improved the result tremendously. To recognize the detected traffic signs, a multi-class Support Vector Machines classifier is used. SVM has proved to be very fruitful over other classifying techniques.
