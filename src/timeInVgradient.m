function [ time ] = timeInVgradient(point1,point2,v0,kz)

% ***********************************************************************************************************
%  timeInVgradient - this function gives the travel time between 2 points with v(z) model
% ***********************************************************************************************************
%
% MIT License
% 
% Copyright (c) 2022 Mark E. Willis
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
% ***********************************************************************************************************

% 
%  [ time ] = timeInVgradient(point1,point2,v0,kz)
%
% *********************************************************************************************
% This routine computes the travel time from point1 to point2 in a medium
%  with a velocity gradient given by V = v0 + kz * z
% *********************************************************************************************
%
% The input parameters:
%
% point1.x = the x location of the first point
% point1.z = the z location of the first point
% point2.x = the x location of the second point
% point2.z = the z location of the second point
%
% v0 = the velocity at the surface of the z coordinate system
% kz = the gradient of the velocity
%
% ***********************************************************************************************
% The output time is given by
%
% Time(from point1 to point2) = abs( 1/kz * arcosh( 1 + kz*kz * r*r / (2* V(point1) * V(point2)))
%
%  where V(z) = v0 + kz * z    and r = distance between points 1 & 2
%
% ***********************************************************************************************

vPoint1 = v0 + kz*point1.z;
vPoint2 = v0 + kz*point2.z;

r = sqrt((point1.x - point2.x).^2 + (point1.z - point2.z).^2);

time = abs( acosh( 1.0 + kz^2 * r.^2 ./(2.0 * vPoint1 .* vPoint2) )/kz);
