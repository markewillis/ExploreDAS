function menuRestoreSession_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  menuRestoreSession_Callback - this function restores a session previously saved to disk
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
% restore the session 
% *************************************************************************

fndefault = 'session.mat';
fndefault = createDefaultOpenFn(fndefault,'session');


[file,path,indx] = uigetfile({'*.mat'},'Select File Name to Save Session',fndefault);
if isequal(file,0)
   return
end

title(XDAS.h.axes_model,'Restoring Session From Disk')
drawnow

fnin = fullfile(path,file);

load(fnin,'CM','copyExploreDAS','copyPaths')
XDAS.obj   = copyExploreDAS;
XDAS.paths = copyPaths;

plotAllPoints

restoreDisplay

updateReflectorListbox

title(XDAS.h.axes_model,'Finished Storing Session From Disk')
drawnow

return

