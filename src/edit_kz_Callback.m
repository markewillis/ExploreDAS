function edit_kz_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  edit_kz_Callback - this function handles the call back from editing the vertical velocity gradient value in the gui
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

newValue = str2double(get(hObject,'Value'));

switch XDAS.h.model.listbox_velocityType.Value
    case 1
        % constant velocity case - never get here!
        
    case 2
        % v(z) case
        
        if isnan(newValue)
            % value entered is not a number - reset to previous value
            set(hObject,'Value',num2str(CM.model.kz))
            return
        end
        if newValue < 0.0000001
            % newValue is less than minimum value - reset to previous value
            set(hObject,'Value',num2str(CM.model.kz))
            return
        end
        
        CM.model.kz = newValue;
        
end

updateDisplay