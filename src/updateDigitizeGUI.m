function updateDigitizeGUI

% ***********************************************************************************************************
%  updateDigitizeGUI - this function updates gui while ditizing data
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
global CMstate

goGreen = XDAS.colors.goGreen;
stopRed = XDAS.colors.stopRed;


% *******************************************************************
% update the well digitizing buttons
% *******************************************************************

well.addButtonColor         = stopRed;
well.deleteButtonColor      = stopRed;
if CMstate.digitizeWell
    if  CMstate.add
        well.addButtonColor    = goGreen;
    else
        well.deleteButtonColor = goGreen;
    end
end
set(XDAS.h.well.pushbutton_add,    'BackgroundColor',well.addButtonColor)
set(XDAS.h.well.pushbutton_delete, 'BackgroundColor',well.deleteButtonColor)
set(XDAS.h.well.pushbutton_reorder,'BackgroundColor',stopRed)

% *******************************************************************
% update the source digitizing buttons
% *******************************************************************

source.addButtonColor           = stopRed;
source.deleteButtonColor        = stopRed;
if CMstate.digitizeSource
    if  CMstate.add
        source.addButtonColor    = goGreen;
    else
        source.deleteButtonColor = goGreen;
    end
end
set(XDAS.h.source.pushbutton_add,      'BackgroundColor',source.addButtonColor)
set(XDAS.h.source.pushbutton_delete,   'BackgroundColor',source.deleteButtonColor)

% *******************************************************************
% update the source digitizing buttons
% *******************************************************************

reflector.startButtonColor    = stopRed;
reflector.reorderButtonColor  = stopRed;
reflector.addButtonColor      = stopRed;
reflector.deleteButtonColor   = stopRed;

if CMstate.digitizeReflector
    if  CMstate.add
        reflector.addButtonColor    = goGreen;
    else
        reflector.deleteButtonColor = goGreen;
    end
end
set(XDAS.h.reflector.pushbutton_startNew,  'BackgroundColor',reflector.startButtonColor)
set(XDAS.h.reflector.pushbutton_add,       'BackgroundColor',reflector.addButtonColor)
set(XDAS.h.reflector.pushbutton_delete,    'BackgroundColor',reflector.deleteButtonColor)
set(XDAS.h.reflector.pushbutton_reorder,   'BackgroundColor',stopRed)

drawnow