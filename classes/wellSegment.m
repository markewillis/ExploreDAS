classdef wellSegment < matlab.mixin.SetGetExactNames
    
% ***********************************************************************************************************
%  wellSegment - this class handles the properties of a well
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
    
    % wellSegments hold well properties
    
    properties
        nwell
        x
        z
        color
        interpx 
        interpz
        MD
    end
    
    properties (Constant)
        interpDistance = 4;  % the distance between points after interpolation of the well trajectory
    end
    
    methods
        function obj = wellSegment()
            
            % wellSegment - Construct an instance of this class

            obj.nwell   = 0;
            obj.x       = [];
            obj.z       = [];
            obj.color   = 'k';
            obj.interpx = []; 
            obj.interpz = [];    
            obj.MD      = [];
        end
        
        function addPoint(obj,x,z)
            
            % addPoint - add a new well point

            obj.nwell = obj.nwell + 1;
            obj.x(obj.nwell) = x;
            obj.z(obj.nwell) = z;
            obj.color = 'k';
            obj.interpx = []; 
            obj.interpz = [];     
            obj.MD      = [];
        end
        
        function deletePoint(obj,x,z)
            
            % deletePoint - delete a well point
            
            if obj.nwell > 1
                % find the closest well point to the digitized point
                [~,index] = min(abs((obj.x - x).^2 + (obj.z - z).^2));
                % omit the closest well point point
                list = 1:obj.nwell;
                mask = list ~= index(1);
                obj.x = obj.x(mask);
                obj.z = obj.z(mask);
                obj.nwell = obj.nwell - 1;
                obj.interpx = [];
                obj.interpz = [];
                obj.MD      = [];
            else
                % all of the points have been deleted
                obj.nwell = 0;
                obj.x = [];
                obj.z = [];
                obj.color = 'k';
                obj.interpx = [];
                obj.interpz = [];
                obj.MD      = [];
            end
        end
        
        function plot(obj,hObject)
            
            % plot - plot out the well trajectory
            
            if obj.nwell > 1
                % plot the picked points for the well
                plot(hObject,obj.x,obj.z,['*' char(obj.color(1))])
                
                % interpolate between the digitized points
                interpPoints(obj);
                
                % now plot the interpolated points
                plot(hObject,obj.interpx,obj.interpz,[char(obj.color(1))],'linewidth',2)
                
            elseif obj.nwell == 1
                
                plot(hObject,obj.x,obj.z,['*' char(obj.color(1))])
                
            end
        end
        
        function interpPoints(obj)
            
            % interpPoints - perform interpolation between the digitized well points
            
            % compute the distance between each digitized point
            interPointDistances = sqrt((obj.x(1:end-1) - obj.x(2:end)).^2 + (obj.z(1:end-1) - obj.z(2:end)).^2);
            
            % compute the integrated distance "arclength' from the first point
            arclength = cumsum(interPointDistances);
            % add the distance from the first point to itself (which is zero)
            arclength = [ 0 arclength(:)']';
            
            % specify the new interpolated points
            pointsToInterpolate = [0:getChannelSpacing:arclength(end)];
            
            % interpolate the x values
            obj.interpx = interp1(arclength,obj.x,pointsToInterpolate );
            % interpolate the z values
            obj.interpz = interp1(arclength,obj.z,pointsToInterpolate );
            
            % create the MD values for each interpolated point - by adding the depth of the first point to the arc lengths
            obj.MD = obj.z(1) + pointsToInterpolate;
            
        end
        
        function reorderPoints(obj)
            
            % reorderPoints - reorder the digitized points to attempt to put them into a logical closest neighbor order
            
            % assume the first point in the old is the first point in the new
            newOrder.x = obj.x;
            newOrder.z = obj.z;
            
            % create a list of available "next points"
            xlist = obj.x(2:end);
            zlist = obj.z(2:end);
            
            for ipoint = 2:obj.nwell-1
                % compute the distance between the last point and all of the other digitized points
                distanceFromCurrentPoint = sqrt((xlist - newOrder.x(ipoint-1)).^2 + (zlist - newOrder.z(ipoint-1)).^2);
                % find the closest point
                [~,index] = min(abs(distanceFromCurrentPoint));
                % found next point - save it to new list
                ifoundPoint = index(1);
                newOrder.x(ipoint) = xlist(ifoundPoint);
                newOrder.z(ipoint) = zlist(ifoundPoint);
                % remove the found point from the list of available points
                list = 1:length(xlist);
                mask = list ~= ifoundPoint;
                xlist = xlist(mask);
                zlist = zlist(mask);
            end
            
            % there is only one point left - add it to the new ordered list
            newOrder.x(obj.nwell) = xlist(1);
            newOrder.z(obj.nwell) = zlist(1);
            
            obj.x = newOrder.x;
            obj.z = newOrder.z;
            
        end
        
        function set.color(obj,color)
            switch color
                case {'r','b','m','k','g','y','w'}
                    obj.color = color;
                otherwise
                    error('wellSegment class error set.color: not a valid color')
            end
        end           
        
        function ok = replace(obj,x,z,color,interpx,interpz,MD)
            
            % replace - this method reinflates the well object with new values
            ok = true;
            nx = length(x);
            nz = length(z);
            if nx == nz
                obj.nwell   = nx;
                obj.x       = x;
                obj.z       = z;
                obj.color   = color;
                obj.interpx = interpx;
                obj.interpz = interpz;
                obj.MD      = MD;     
            else
                % the data is inconsistent!
                ok = false;
                error('wellSegment Class Error replace: nx and nz are different sizes')
            end
        end
        
    end
    
end

