classdef reflectionList < matlab.mixin.SetGetExactNames
    
% ***********************************************************************************************************
%  reflectionList - this class handles list of reflectors
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

    % reflectionList mother Structure of all reflection segments
    
    properties
        nsegments
        segments
    end
    
    methods
        function obj = reflectionList()
            
            % reflectionList Construct an empty instance of this class
            obj.nsegments = 0;
            obj.segments  = [];
        end
 
        
        function found = selectSegment(obj,segmentNumber)
            
            % selectSegment return the desired segment object

            if segmentNumber < 1
                % error trying to obtain a negative list number object
                found = [];
                disp(['Error: trying to access a negative reflection segment number'])
                return
            end
            
            pickSegment = max(1,min(segmentNumber,obj.nsegments));
            found = obj.segments(pickSegment);
        end      
        
        function addSegment(obj)
            
            % addSegment create a new reflection segment

            obj.nsegments = obj.nsegments + 1;
            if obj.nsegments > 1
                obj.segments = [obj.segments, reflectionSegment(obj.nsegments)];
            else
                obj.segments = reflectionSegment(1);
            end
        end

        function addFilledSegment(obj,x,z,color,interpx,interpz)
            
            % addSegment create a new reflection segment

            obj.nsegments = obj.nsegments + 1;
            if nargin == 1
                % default case - create empty object
                obj.segments = [obj.segments, reflectionSegment(obj.nsegments)];
            elseif nargin == 3
                % create object with just x & z input values
                obj.segments = [obj.segments, reflectionSegment(obj.nsegments,x,z)];
            elseif nargin == 6
                % create object with all input values
                obj.segments = [obj.segments, reflectionSegment(obj.nsegments,x,z,color,interpx,interpz)];
            else
                disp('reflectionList Class Error: cannot create  a new reflectionSegment - not enough input parameters')
            end
        end        
        
        function [done, reaction] = modifySegment(obj,action,thisSegment,x,z)
            % modifySegment modify a reflection segment
            
            done     = false;
            reaction = 'none';
            
            if thisSegment > obj.nsegments
                disp([' Error: reflector segment ' num2str(thisSegment) ' is outside of range. Max = ' num2str(obj.nsegment)])
                done = true;
                return
            end
            
            switch action
                case 'add'
                    obj.segments(thisSegment).addPoint(x,z);
                    
                case 'delete'
                    [done, reaction] = obj.segments(thisSegment).deletePoint(x,z);
                    
                    if done
                        if obj.nsegments < 2
                            % there is only 1 or 0 reflectors in the list, reset the entire structure
                            obj.nsegments = 0;
                            obj.segments  = [];
                            
                            reaction = 'no reflectors left';
                            
                        else
                            % there are more than 1 reflectors, just delete the selected reflector from the list
                            list = 1:obj.nsegments;
                            selectionMask = list ~= thisSegment;
                            obj.segments = obj.segments(selectionMask);
                            obj.nsegments = length(obj.segments);
                            
                            reaction = 'remove this reflector from list';
                            
                        end
                    end
            end
        end
        
        function [visible] = plot(obj,hObject)
            
            % plot all of the reflectors
            
            % loop over all reflectors
            if obj.nsegments > 0
                for ireflector = 1:obj.nsegments
                    obj.segments(ireflector).plot(hObject)
                end
                % there are reflectors to plot, so set the text and listbox for the reflector list to be visible
                visible = 'on';    
            else
                % there are NO reflectors to plot, so set the text and listbox for the reflector list to be invisible
                visible = 'off';
            end
        end
        
        function [visible] = plotColor(obj,hObject)
            
            % plot the reflectors with color

            % loop over all reflectors
            if obj.nsegments > 0
                for ireflector = 1:obj.nsegments
                    obj.segments(ireflector).plotColor(hObject)
                end
                % there are reflectors to plot, so set the text and listbox for the reflector list to be visible
                visible = 'on';    
            else
                % there are NO reflectors to plot, so set the text and listbox for the reflector list to be invisible
                visible = 'off';
            end
        end
                
        function highLightSegment(obj,hObject,selectedSegment)
            
            % plot the selected segment as "highlighted"
            
            % first we delete any highlighted reflectors
            hhighlight = findobj(hObject,'Tag','Rselected');
            if ~isempty(hhighlight)
                delete(hhighlight)
            end
            
            if selectedSegment < obj.nsegments+1
                plot(hObject,obj.segments(selectedSegment).x, obj.segments(selectedSegment).z,'*r','Tag','Rselected')
            end
        end
        
        function nsegments = get.nsegments(obj)
            
            % getter function for nsegments
            nsegments = obj.nsegments;
        end
    end
end

