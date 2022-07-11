function [xinterp, zinterp, newpoints] = interpPoints2(x,z,interpDistance)

% ***********************************************************************************************************
%  interpPoints2 - this function interpolates between input list of points with a constant distance interpDistance
%
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

% compute the distance between each digitized point
interPointDistances = sqrt((x(1:end-1) - x(2:end)).^2 + (z(1:end-1) - z(2:end)).^2);

% compute the integrated distance "arclength' from the first point
arclength = cumsum(interPointDistances);
% add the distance from the first point to itself (which is zero)
arclength = [ 0 arclength(:)']';

% specify the new interpolated points
newpoints = [0:interpDistance:arclength(end)];

% interpolate the x values
xinterp = interp1(arclength,x,newpoints);
% interpolate the z values
zinterp = interp1(arclength,z,newpoints);

