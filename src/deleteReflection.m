function [done] = deleteReflection(x,z,selectedReflector)

% ***********************************************************************************************************
%  deleteReflection - this function handles deleting parts of a reflector
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

% delete a point on the reflector
[done, reaction] = XDAS.obj.reflectors.modifySegment('delete',selectedReflector,x,z);

switch reaction 
    
    case 'none'
        
        return
        
    case 'deleted point'
        
        % update the plotted points before giving the user a status message
        plotAllPoints
        listbox_selectReflector_Callback([], [])
        
        title(XDAS.h.axes_model,['Deleted Point From Reflector ' num2str(selectedReflector)],'fontsize',16,'fontweight','bold')
        pause(0.2)
        title(XDAS.h.axes_model,['Click Left Mouse Button to delete Reflector points, Right Mouse Button to quit'],'fontsize',16,'fontweight','bold')
        
        return
        
    case 'no reflectors left'
        
        % update the plotted points before giving the user a status message
        plotAllPoints
        
        title(XDAS.h.axes_model,['Deleted last point, there are no Reflectors remaining '],'fontsize',16,'fontweight','bold')
        pause(0.5)
        title(XDAS.h.axes_model,['Select a new command'],'fontsize',16,'fontweight','bold')
        
    case  'remove this reflector from list'
        
        % update the plotted points before giving the user a status message
        plotAllPoints
        listbox_selectReflector_Callback([], [])
        
        title(XDAS.h.axes_model,['Deleted last point in this reflector, removing this reflector from the list '],'fontsize',16,'fontweight','bold')
        pause(0.5)
        title(XDAS.h.axes_model,['Select a new command'],'fontsize',16,'fontweight','bold')
                            
end

% update the new reflector list box - because the number of reflectors has changed - select the last reflector to be active
updateReflectorListbox
  
