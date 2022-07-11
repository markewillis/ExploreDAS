function edit_fmin_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  edit_fmin_Callback - this function handles the call back from editing the fmin value in the gui
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

%
% this routine doubles for both f0 for Ricker wavelets and fmin for Klauder wavelets
%
%  so both need to be handled correctly
%

global CM
global XDAS

newValue = str2double(get(hObject,'Value'));

switch get(XDAS.h.simulation.listbox_sourceType,'Value')
    case 1
        % Ricker wavelet
        default = CM.model.f0;
    case 2
        % Klauder wavelet
        default = CM.model.fmin;
end

if isnan(newValue) || newValue < 1
    % value entered is not a number or is less than min - reset to previous value
    set(hObject,'Value',num2str(default))
    return
end

% new number passes the test, set the model parameter appropriately
switch get(XDAS.h.simulation.listbox_sourceType,'Value')
    case 1
        % Ricker wavelet
        CM.model.f0   = newValue;
    case 2
        % Klauder wavelet
        CM.model.fmin = newValue;
end
