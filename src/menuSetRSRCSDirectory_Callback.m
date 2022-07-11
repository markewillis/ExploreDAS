function menuSetRSRCSDirectory_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  menuSetRSRCSDirectory_Callback - this function sets the resources directory for the project
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


global CM
global XDAS

% *************************************************************************
% ask the user for a directory for the resources
% *************************************************************************

dirDefault = pwd;

[path] = uigetdir(dirDefault,'Select Folder Name for Resources');
if isequal(path,0)
   return
end

CM.paths.rsrcs = path;

% set switch to generate optical noise rather than use measurement
CM.fiber.ifNoiseFromFile = true;

% toggle off the menu item for the directory with noise measurements
XDAS.h.menu_setGenerateNoise.Checked = 'off';
XDAS.h.menu_setRSRCSDirectory.Checked = 'on';