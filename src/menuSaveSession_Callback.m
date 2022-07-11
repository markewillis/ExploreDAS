function menuSaveSession_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  menuSaveSession_Callback - this function saves a session to disk
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
% save a matlab formatted file - containing model structure
% *************************************************************************

fndefault = 'session.mat';
fndefault = createDefaultSaveFn(fndefault);


[file,path,indx] = uiputfile({'*.mat'},'Select File Name to Save Session',fndefault);
if isequal(file,0)
   return
end

CM.paths.session = fullfile(path,file);


title(XDAS.h.axes_model,'Saving Session To Disk')
drawnow

fnout = fullfile(path,file);

copyExploreDAS = XDAS.obj;
copyPaths      = XDAS.paths;
save(fnout,'CM','copyExploreDAS','copyPaths')

title(XDAS.h.axes_model,'Finished Saving Session To Disk')
drawnow

return

