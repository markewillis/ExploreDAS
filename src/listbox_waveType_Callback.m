function listbox_waveType_Callback(~, ~)

% ***********************************************************************************************************
%  listbox_waveType_Callback - this function handles the selection of a source wave type being selected
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
global CM

%{'P DAS', 'S DAS', 'P Vertical', 'S Horizontal'};

wavetype = char(XDAS.h.simulation.listbox_waveType.Items(XDAS.h.simulation.listbox_waveType.Value));

switch wavetype
    case {'P DAS', 'S DAS'}
        % allow the use of the gauge on DAS data
        XDAS.h.simulation.pushbutton_useGL.Visible = 'on';
    otherwise
        % cannot use the gauge for geophone data
        XDAS.h.simulation.pushbutton_useGL.Visible = 'off';
end

CM.model.waveType = wavetype;

updateDisplay;