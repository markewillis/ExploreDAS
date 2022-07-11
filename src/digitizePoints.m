function digitizePoints

% ***********************************************************************************************************
%  digitizePoints - this function handles digitizing points on the gui
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
global CMstate

updateDigitizeGUI

infoTitle = createTitle;

% update title on the model to instruct user what to do next
title(XDAS.h.axes_model,infoTitle,'fontsize',16,'fontweight','bold')

while true
    
    % make sure pointer is the cross hair
    XDAS.h.figure1.Pointer = 'crosshair';

    %[x,z,button] = ginputuiaxButtonClick(XDAS.h.axes_model,1);
    [x,z,button] = ginputuiaxButtonClickBetter(XDAS.h.axes_model,1,XDAS.h.digitize.text_odometer);
    
    % check if user is finished
    if button == 3
        break
    end
    
    if isempty(x) || isempty(z)
        
        % bad point was digitized - skip over it
        title(XDAS.h.axes_model,['Click was outside of model, try again'],'fontsize',16,'fontweight','bold')
        
    else
        
        if CMstate.digitizeSource
            % ****************************************
            % Source points
            % ****************************************
            
            % Source digitizing
            if CMstate.add
                addSource(x,z,'r')
            else
                % user wants to delete a point
                deleteSource(x,z)
            end
                     
        elseif CMstate.digitizeWell
            % ****************************************
            % Well points
            % ****************************************
            
            % Well digitizing
            if CMstate.add
                % user wants to add a point
                addWell(x,z,'k')
            else
                % user wants to delete a point
                deleteWell(x,z)
            end
            
        elseif CMstate.digitizeReflector
            % ****************************************
            % Reflector points
            % ****************************************
            
            % Reflector digitizing
            
            % get the current reflector to edit
            selectedReflector = get(XDAS.h.reflector.listbox_reflectors,'value');   
            listbox_selectReflector_Callback([], [])
            if CMstate.add
                % user wants to add a point
                addReflection(x,z,'b',selectedReflector)
            else
                % user wants to delete a point
                done = deleteReflection(x,z,selectedReflector);
                if done
                    % no more points
                    break
                end
            end
        end
        
        % update the informational title 
        title(XDAS.h.axes_model,infoTitle,'fontsize',16,'fontweight','bold')
    end
    
end

% return pointer is the arrow
XDAS.h.figure1.Pointer = 'arrow';

XDAS.h.digitize.text_odometer.Visible = 'off';

% update title on the model to instruct user what to do next
title(XDAS.h.axes_model,['Model'],'fontsize',16,'fontweight','bold')

setState('reset','none')
updateDigitizeGUI

function [infoTitle] = createTitle

global CMstate

switch CMstate.add
    case 1
        infoTitle = ['Click Left Mouse Button to add '];
    otherwise
        infoTitle = ['Click Left Mouse Button to delete'];
end
if     CMstate.digitizeSource
       infoTitle = [infoTitle 'Source points, Right Mouse Button to quit'];
elseif CMstate.digitizeWell
       infoTitle = [infoTitle 'Well points, Right Mouse Button to quit'];
else
       infoTitle = [infoTitle 'reflector points, Right Mouse Button to quit'];
end
