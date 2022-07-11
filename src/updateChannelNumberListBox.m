function updateChannelNumberListBox()

% ***********************************************************************************************************
%  updateChannelNumberListBox - this function updates the channel list in the dropdown box
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

pass = true;

if ~isfield(XDAS.obj,'shotRecords') || isempty(XDAS.obj.shotRecords) 
    
    % there are no shots
    pass = false;
    
else
    
    nchannels = get(XDAS.obj.shotRecords(1),'nchannels');
    wellMD    = get(XDAS.obj.shotRecords(1),'wellMD');
    
end


if pass && nchannels > 0
    
    % create the list of current source records
    for ichannel = 1:nchannels
        %list{ichannel} = num2str(ichannel);
        list{ichannel} = num2str(round(wellMD(ichannel)));
    end
    XDAS.h.simulation.listbox_channelNumber.Items = list;
    XDAS.h.simulation.listbox_channelNumber.ItemsData = 1:nchannels;
    XDAS.h.simulation.listbox_channelNumber.Value = 1;
    
    set(XDAS.h.simulation.listbox_channelNumber,'visible','on')
    set(XDAS.h.simulation.text_channelNumber,   'visible','on')

else
    % there are no sources - hide the functionality for reflectors
    set(XDAS.h.simulation.listbox_channelNumber,'visible','off')
    set(XDAS.h.simulation.text_channelNumber,   'visible','off')
    
end

drawnow