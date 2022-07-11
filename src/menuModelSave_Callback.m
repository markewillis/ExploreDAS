function menuModelSave_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  menuModelSave_Callback - this function saves a model file in JSON format
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

fndefault = 'model.txt';
fndefault = createDefaultSaveFn(fndefault);

[file,path,indx] = uiputfile({'*.txt';'*.TXT'},'Select File Name to Save Model',fndefault);
if isequal(file,0)
   return
end

CM.paths.model = fullfile(path,file);

title(XDAS.h.axes_model,'Saving Model To Disk')
drawnow

% create a new structure to hold all of the objects and parameters

EDAS.CM         = CM;
EDAS.well       = XDAS.obj.well;
EDAS.sources    = XDAS.obj.sources;
EDAS.reflectors = XDAS.obj.reflectors;

% create the JSON text string with the movel saved
fnout   = fullfile(path,file);

% convert the zigzags structure to a JSON character string
zz = jsonencode(EDAS);

% open the output file and write out the JSON object
fid = fopen(fnout,'w');
fprintf(fid,'%s',zz);
fclose(fid);

title(XDAS.h.axes_model,'Finished Saving Model To Disk')
drawnow

% save the name of the model file
CM.paths.modelFile = fnout;

return

