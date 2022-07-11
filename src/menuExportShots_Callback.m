function menuExportShots_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  menuExportShots_Callback - this function exports shot records in .mat format
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

global CM
global XDAS

% *************************************************************************
% ask the user for a directory to put all of the exported shot data then export them
% *************************************************************************

dirDefault = createDefaultSaveDir();

[path] = uigetdir(dirDefault,'Select Folder Name for Saving Shots');
if isequal(path,0)
   %disp('User selected Cancel')
   return
end

title(XDAS.h.axes_model,['Exporting Shots To Disk in directory ' path])
drawnow

% create a new structure to hold all of the objects and parameters

EDAS.CM         = CM;
EDAS.well       = XDAS.obj.well;
EDAS.sources    = XDAS.obj.sources;
EDAS.reflectors = XDAS.obj.reflectors;

% save the model information in a new file
fname = ['modelData.mat'];
fnout   = fullfile(path,fname);
save(fnout,'EDAS')

% save each shot record separately
for ishot = 1:get(XDAS.obj.sources,'nsource')
    
    % make a copy of the handle to this shot record - easier to write
    thisShotRecord = XDAS.obj.shotRecords(ishot);
    
    % restore data from disk
    thisShotRecord.restoreFromDisk();
    
    % create the file name into which to export the shot data
    fname = ['shot_' num2str(ishot) '_Record.mat'];
    fnout   = fullfile(path,fname);
    
    % save the shot record to disk
    [fail] = thisShotRecord.saveToDisk(fnout);
    
    % purge the traces for this shot 
    thisShotRecord.purgeTraces();

    if fail
        title(XDAS.h.axes_model,['Failed Saving Shot ' num2str(ishot) ' To Disk, Aborting'])
        drawnow
        return
    else
        title(XDAS.h.axes_model,['Finished Saving Shot ' num2str(ishot) ' To Disk'])
    end
    drawnow
    
end

title(XDAS.h.axes_model,['Finished Saving All Shots To Disk'])
drawnow
return

