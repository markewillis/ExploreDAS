function menuExportMigrationSEGY_Callback(~, ~)

% ***********************************************************************************************************
%  menuExportMigration_Callback - this function exports migrated data in SGY format
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

global XDAS

% *************************************************************************
% ask the user for a directory to put all of the exported shot data then export them
% *************************************************************************

dirDefault = createDefaultSaveDir();

[tpath] = uigetdir(dirDefault,'Select Folder Name for Saving Migrated Images');
if isequal(tpath,0)
   return
end

title(XDAS.h.axes_model,['Exporting Migration Results in SEGY format To Disk in directory ' tpath])
drawnow

% create the file name into which to export the migrated images
filenameRef = ['migratedImage_Ref.sgy'];
filenameRef = fullfile(tpath,filenameRef);

filenameOther = ['migratedImage_Other.sgy'];
filenameOther = fullfile(tpath,filenameOther);

polarity = false;

[fail] = XDAS.obj.migratedImagePair.saveToSEGY(filenameRef,filenameOther,polarity);

if fail
    title(XDAS.h.axes_model,['Failed to Save Migrated Images To Disk'])
else
    title(XDAS.h.axes_model,['Finished Saving Migrated Images To Disk'])
end
drawnow
    
return

