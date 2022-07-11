function updateSourceNumberListBox()

% ***********************************************************************************************************
%  updateSourceNumberListBox - this function updates the dropdown list of sources
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

nsources = get(XDAS.obj.sources,'nsource');

if nsources > 0 && isfield(XDAS.obj,'shotRecords') && length(XDAS.obj.shotRecords) >= nsources
    
    % create the list of current source records
    for ishot = 1:nsources
        list{ishot} = num2str(get(XDAS.obj.shotRecords(ishot),'shotNumber'));
    end
    XDAS.h.simulation.listbox_sourceNumber.Items = list;
    XDAS.h.simulation.listbox_sourceNumber.ItemsData = 1:nsources;
    XDAS.h.simulation.listbox_sourceNumber.Value = nsources;
    
    set(XDAS.h.simulation.listbox_sourceNumber,'visible','on')
    set(XDAS.h.simulation.text_sourceNumber,   'visible','on')

else
    % there are no sources - hide the functionality for reflectors
    set(XDAS.h.simulation.listbox_sourceNumber,'visible','off')
    set(XDAS.h.simulation.text_sourceNumber,   'visible','off')
    
end

drawnow