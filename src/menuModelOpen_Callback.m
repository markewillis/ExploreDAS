function menuModelOpen_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  menuModelOpen_Callback - this function opens a model file in JSON format
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

% *************************************************************************
% open a JSON objects formatted file
% *************************************************************************

global CM
global XDAS

fndefault = 'model.txt';
fndefault = createDefaultOpenFn(fndefault,'model');


[file,path,indx] = uigetfile({'*.txt';'*.TXT'},'Select the Model Text File to Open',fndefault);
if isequal(file,0)
   return
end

% read in the text file with the project saved
fnin   = fullfile(path,file);

title(XDAS.h.axes_model,'Starting to Read Model From Disk')
drawnow

% open the input file and read in the CM JSON object
fid = fopen(fnin,'r');
zz = fscanf(fid,'%s');
fclose(fid);

EDAS = jsondecode(zz);

EDAS = validateEDAS(EDAS);

% replace the CM structure
CM.simulation      = EDAS.CM.simulation;
CM.model           = EDAS.CM.model;
CM.fiber           = EDAS.CM.fiber;
CM.paths.modelFile = fnin;
% do not change the data path - this is not a back up of project just the model
%CM.paths.data 

% inflate the well object with the new well data
XDAS.obj.well = wellSegment;
XDAS.obj.well.replace(EDAS.well.x,EDAS.well.z,EDAS.well.color,EDAS.well.interpx,EDAS.well.interpz,EDAS.well.MD);

% inflate the sources object with the new source data
XDAS.obj.sources = sourcePoints;
XDAS.obj.sources.replace(EDAS.sources.x,EDAS.sources.z,EDAS.sources.color);

% reconstruct the reflector object with the data
XDAS.obj.reflectors = reflectionList;

for isegment = 1:EDAS.reflectors.nsegments    
    % create a new segment
    XDAS.obj.reflectors.addFilledSegment(EDAS.reflectors.segments(isegment).x,EDAS.reflectors.segments(isegment).z);

    % add the reflection coeficient if it is present
    if isfield(EDAS.reflectors.segments(isegment),'reflectionCoeficientScalar')
        set(XDAS.obj.reflectors.segments(isegment),'reflectionCoeficientScalar',EDAS.reflectors.segments(isegment).reflectionCoeficientScalar)
    end

end
 
title(XDAS.h.axes_model,'Finished Reading Model From Disk')
drawnow

plotBackgroundImage

plotAllPoints

updateDisplay

updateNoiseGUI

updateReflectorListbox


return



