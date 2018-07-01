% Defining rotation, transition and calibration matrix
K = [800,0,250,0; 0,800,250,0;0,0,1,0]; %Calibration matrix
Theta = 20; % rotated by angle 20?
R = [1,0,0,0;0, cosd(Theta), -sind(Theta),0;0,(sind(Theta)),cosd(Theta),0;0,0,0,1]; %Rotation matrix
T = [1,0,0,0;0,1,0,0;0,0,1,10;0,0,0,1]; %Transition matrix
M = K*R*T;

% Defining the vertices of the cube
C1 = [0;0;0;1]; C2 = [1;0;0;1];
C3 = [1;1;0;1]; C4 = [0;1;0;1];
C5 = [1;1;1;1]; C6 = [1;0;1;1];
C7 = [0;0;1;1]; C8 = [0;1;1;1];

% Finding the image plane points corresponding to the world coordinates
C1 = M*C1; C2 = M*C2;
C3 = M*C3; C4 = M*C4;
C5 = M*C5; C6 = M*C6;
C7 = M*C7; C8 = M*C8;

% Finding co-ordinates of the image from homogeneous co-ordinates
p1 = (C1(1,1)/C1(3,1)); q1 = (C1(2,1)/C1(3,1));
p2 = (C2(1,1)/C2(3,1)); q2 = (C2(2,1)/C2(3,1));
p3 = (C3(1,1)/C3(3,1)); q3 = (C3(2,1)/C3(3,1));
p4 = (C4(1,1)/C4(3,1)); q4 = (C4(2,1)/C4(3,1));
p5 = (C5(1,1)/C5(3,1)); q5 = (C5(2,1)/C5(3,1));
p6 = (C6(1,1)/C6(3,1)); q6 = (C6(2,1)/C6(3,1));
p7 = (C7(1,1)/C7(3,1)); q7 = (C7(2,1)/C7(3,1));
p8 = (C8(1,1)/C8(3,1)); q8 = (C8(2,1)/C8(3,1));

% Ploting the lines which connect the points of the cube on image plane
X1  = [p7,p6]; Y1  = [q7,q6];
X2  = [p6,p5]; Y2  = [q6,q5];
X3  = [p5,p8]; Y3  = [q5,q8];
X4  = [p8,p7]; Y4  = [q8,q7];
X5  = [p5,p3]; Y5  = [q5,q3];
X6  = [p3,p4]; Y6  = [q3,q4];
X7  = [p1,p7]; Y7  = [q1,q7];
X8  = [p1,p4]; Y8  = [q1,q4];
X9  = [p1,p2]; Y9  = [q1,q2];
X10 = [p2,p3]; Y10 = [q2,q3];
X11 = [p2,p6]; Y11 = [q2,q6]; 
X12 = [p4,p8]; Y12 = [q4,q8];

line(X1,Y1); line(X2,Y2);
line(X3,Y3); line(X4,Y4);
line(X5,Y5); line(X6,Y6);
line(X7,Y7); line(X8,Y8);
line(X9,Y9); line(X10,Y10);
line(X11,Y11); line(X12,Y12);
