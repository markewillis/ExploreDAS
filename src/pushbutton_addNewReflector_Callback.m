function pushbutton_addNewReflector_Callback(~, ~)

% ***********************************************************************************************************
%  pushbutton_addNewReflector_Callback - this function adds a new reflector
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

global XDAS

goGreen = [.81 .97 .71];
stopRed = [1 .7 .7];

setState('reflector','Add')

set(XDAS.h.reflector.pushbutton_startNew,'BackgroundColor',goGreen)
drawnow

% add a new reflector
XDAS.obj.reflectors.addSegment();

% set up reflector list dropdown list
updateReflectorListbox


% update title on the model to instruct user what to do next
title(XDAS.h.axes_model,['Push Add or Delete Button to add or delete points, or Reorder Button to order the points'],'fontsize',16,'fontweight','bold')

set(XDAS.h.reflector.pushbutton_startNew,'BackgroundColor',stopRed)
drawnow
