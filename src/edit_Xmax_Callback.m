function edit_Xmax_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  edit_Xmax_Callback - this function handles the call back from editing the model maximum X value in the gui
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

global CM

% default value
% CM.model.xmax = 5000;

newValue = str2double(get(hObject,'Value'));

if isnan(newValue)
    % value entered is not a number - reset to previous value
    set(hObject,'Value',num2str(CM.model.xmax))
    return
end
if newValue < CM.model.xmin
    % newValue is less than minimum value - reset to previous value
    set(hObject,'Value',num2str(CM.model.xmax))
    return
end

CM.model.xmax = newValue;

updateDisplay
