function [directionCosines] = createWellDirectionCosines(x,z)

% ***********************************************************************************************************
%  createWellDirectionCosines - this function creates the direction cosines of the well trajectory
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

% create the unit vectors (direction cosines for the well trajectory)
%  with increasing depth

nchannels = length(x);

directionCosines = zeros(2,nchannels);

for ichannel = 2:nchannels-1
    dx = (x(ichannel+1) - x(ichannel-1));
    dz = (z(ichannel+1) - z(ichannel-1));
    
    directionCosines(:,ichannel) = [dx,dz]/sqrt(dx^2 + dz^2);    
end

% fix the endpoints which can't be computed directly by a 3 point operator
directionCosines(:,  1) = directionCosines(:,2);
directionCosines(:,end) = directionCosines(:,end-1);

