function menuReadImage_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  menuReadImage_Callback - this function reads a jpeg image to display behind the digitizing
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
% open a jpeg image to display behind the model
% *************************************************************************

global CM
global XDAS

fndefault = 'modelImage.jpg';

[file,path,indx] = uigetfile({'*.jpg'},'Select the Image File to Open to Display Behind the Model',fndefault);
if isequal(file,0)
   return
end

% read in the text file with the project saved
CM.model.fnModel   = fullfile(path,file);

title(XDAS.h.axes_model,'Starting to Image File From Disk')
drawnow

% open the input file and read in the CM JSON object
fullImage = imread(CM.model.fnModel);


title(XDAS.h.axes_model,'Finished Reading Image File From Disk')
drawnow


figure
imagesc(fullImage)
title('Pick upper left model corner')
[x1,z1] = ginput(1);
title('Pick lower right model corner')
[x2,z2] = ginput(1);

[nz,nx,ncolor] = size(fullImage);

xstart = max(1,round(min([x1 x2])));
zstart = max(1,round(min([z1 z2])));
xend   = min(nx,round(max([x1 x2])));
zend   = min(nz,round(max([z1 z2])));

% save the input & cropped model information
CM.model.imageCropXStart = xstart;
CM.model.imageCropZStart = zstart;
CM.model.imageCropXend   = xend;
CM.model.imageCropZend   = zend;

newImage = fullImage(zstart:zend,xstart:xend,:);
figure
imagesc([CM.model.xmin CM.model.xmax],[CM.model.zmin CM.model.zmax],newImage)

% save the new background image to the global structure
CM.model.modelImage = newImage;

% make the pushbutton to show the background image set to available
set(XDAS.h.well.pushbutton_showImage,'visible','on')
CM.model.ifShowBackgroundImage = true;

% change the checked box on the menu to show that they have read in an image
XDAS.h.menu_readInImage.Checked = 'on';


plotBackgroundImage

plotAllPoints

updateDisplay

updateReflectorListbox



return




