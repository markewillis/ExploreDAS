function [newOrder] = reorderPoints(oldOrder)

% ***********************************************************************************************************
%  reorderPoints - this function reorders points in a list to be ordered by closest neighbor
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

npoints = length(oldOrder.x);

% create the structure to hold the new ordered list of points
newOrder = oldOrder;
% assume the first point in the old is the first point in the new
newOrder.x = oldOrder.x(1);
newOrder.z = oldOrder.z(1);

% create a list of available "next points"
xlist = oldOrder.x(2:end);
zlist = oldOrder.z(2:end);

for ipoint = 2:npoints-1
    % compute the distance between the last point and all of the other digitized points
    distanceFromCurrentPoint = sqrt((xlist - newOrder.x(ipoint-1)).^2 + (zlist - newOrder.z(ipoint-1)).^2);
    % find the closest point
    [~,index] = min(abs(distanceFromCurrentPoint));
    % found next point - save it to new list
    ifoundPoint = index(1);
    newOrder.x(ipoint) = xlist(ifoundPoint);
    newOrder.z(ipoint) = zlist(ifoundPoint);
    % remove the found point from the list of available points
    list = 1:length(xlist);
    mask = list ~= ifoundPoint;
    xlist = xlist(mask);
    zlist = zlist(mask);
end

% there is only one point left - add it to the new ordered list
newOrder.x(npoints) = xlist(1);
newOrder.z(npoints) = zlist(1);
