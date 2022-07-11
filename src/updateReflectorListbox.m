function updateReflectorListbox

% ***********************************************************************************************************
%  updateReflectorListbox - this function updates the dropdown list of reflectors
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

if XDAS.obj.reflectors.nsegments > 0
    % create the list of current reflectors
    for ireflector = 1:get(XDAS.obj.reflectors','nsegments')
        list{ireflector} = num2str(ireflector);
    end
    XDAS.h.reflector.listbox_reflectors.Items = list;
    XDAS.h.reflector.listbox_reflectors.ItemsData = 1:get(XDAS.obj.reflectors','nsegments');
    set(XDAS.h.reflector.listbox_reflectors,'value',get(XDAS.obj.reflectors','nsegments'))
    
    set(XDAS.h.reflector.listbox_reflectors,  'visible','on')
    set(XDAS.h.reflector.text_selectReflector,'visible','on')
    set(XDAS.h.reflector.pushbutton_add,      'visible','on')
    set(XDAS.h.reflector.pushbutton_delete,   'visible','on')
    set(XDAS.h.reflector.pushbutton_reorder,  'visible','on')

else
    % there are no reflectors - hide the functionality for reflectors
    set(XDAS.h.reflector.text_selectReflector,'visible','off')
    set(XDAS.h.reflector.listbox_reflectors,  'visible','off')
    set(XDAS.h.reflector.pushbutton_add,      'visible','off')
    set(XDAS.h.reflector.pushbutton_delete,   'visible','off')
    set(XDAS.h.reflector.pushbutton_reorder,  'visible','off')
    
end

drawnow
