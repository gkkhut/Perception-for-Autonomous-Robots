clc
clear all
%A = rotx(45)*rotz(30)
z = pi/6;
Rz = [cos(z)  -sin(z)   0
      sin(z)   cos(z)   0 
        0        0     1]

x = pi/4;
Rx = [  1       0        0
        0     cos(x)  -sin(x) 
        0     sin(x)   cos(x)]
A = Rx * Rz