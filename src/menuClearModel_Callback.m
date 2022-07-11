function menuClearModel_Callback(hObject, eventdata)

% ***********************************************************************************************************
%  menuClearModel_Callback - this function clears (deletes) the current model in memory
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

% clear the current model from memory and start from scratch


% check to see if the user really wants to delete the current model

hfig = uifigure;
msg = 'Do you really want to discard the current model and start a new model from scratch?';
ttitle = 'Clear Current Model';

selection = uiconfirm(hfig,msg,ttitle,'Options',{'Delete Current Model','Cancel'}, ...
                      'DefaultOption',2,'CancelOption',2);
                  
delete(hfig)
                  
switch selection
    case 'Cancel'
        % the user does not want to clear the model
        title(XDAS.h.axes_model,'Keep the current model')
        return
    otherwise
        % the user wants to clear this model from memory and start over
        resetModel       
        title(XDAS.h.axes_model,'Deleted the current model')
end
        
       