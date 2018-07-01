clc
clear all
% B = rotz(30)*rotx(45)
z = pi/6;
Rz = [cos(z) -sin(z)   0
      sin(z)  cos(z)   0 
        0        0     1]

x = pi/4;
Rx = [  1       0        0
        0     cos(x)  -sin(x) 
        0     sin(x)   cos(x)]
B = Rz * Rx
